$('form.document').each ->
  form = $ @
  schema = {}

  create_item = ->
    item = $ '<div/>', {class: 'item'}
    # Loop items properties
    for own key, value of schema.items.properties
      # Default variabiles
      field = $ '<input/>', {type: 'text'}
      data_type = 'string'

      # Check enum SELECT
      if value.enum?.length
        field = $ '<select/>', {class: 'inline'}
        for option in value.enum
          field.append $ '<option/>', {value: option, text: option}

      # Check property type and format
      switch value.type
        when 'string'
          switch value.format
            when 'textarea'
              field = $ '<textarea/>', {'data-skip-falsy': true, spellcheck: false}
              data_type = 'textarea'
            when 'date' then field.attr 'type','date'
            when 'uri' then field.attr 'type', 'url'
            when 'date-time' then field.attr 'type', 'datetime-local'
            when 'email', 'color', 'time' then field.attr 'type', value.format
        when 'number', 'integer'
          data_type = 'number'
          field.attr 'type', 'number'
          field.attr 'data-value-type', 'number'
          if value.format is 'range'
            data_type = 'range'
            field.attr 'type', 'range'
        when 'boolean'
          data_type = 'select'
          field = $('<select/>',
            class: 'inline'
            'data-value-type': 'boolean'
          ).append [
            $ '<option/>', {value: true, text: 'True'}
            $ '<option/>', {value: false, text: 'False'}
          ]
        else notification "Property type `#{value.type}` to do", 'red', true

      # Complete field attributes
      field.attr 'name', "#{key}"
      # Classes
      if value.class then field.addClass value.class
      # String
      if value.maxLength then field.attr 'maxlength', value.maxLength
      if value.minLength then field.attr 'minlength', value.minLength
      if value.pattern then field.attr 'pattern', value.pattern
      # Number
      if value.minimum then field.attr 'min', value.minimum
      if value.maximum then field.attr 'max', value.maximum
      # Default
      if value.default
        if value.format is 'date' and value.default is 'today'
          # Today date with leading zeros
          field.val new Date().toLocaleDateString('en-CA')
        else field.val value.default
      # Prepare elements
      label = $ '<label/>', {text: value.title || key, for: "#{key}"}
      div = $ '<div/>', {'data-type': data_type}
      # Integer
      if value.type is 'integer' then field.attr 'step', 1
      # Append label and field to DIV, add whitespace for inline SELECTs
      div.append [label, " ", field]
      # Append output element for RANGE
      if value.format is 'range'
        div.append $('<output/>', {for: key})
        range_enable field
      # Append description SPAN
      if value.description then div.append $('<span/>': {text: value.description})
      # Append DIV to ITEM
      item.append div
    # End properties loop
    return item # End create_item

  load_schema = ->
    path = form.attr 'data-schema'
    # Prepend user folder if repository is forked
    if storage.get("repository.fork")
      path = "user/#{storage.get 'login.user'}/#{path}"
    schema_url = "{{ site.github.api_url }}/repos/{{ site.github.repository_nwo }}/contents/_data/#{path}.schema.json"
    form.attr 'disabled', ''
    get_schema = $.get schema_url
    get_schema.done (data, status) ->
      # Get schema: decode from base 64 and parse as yaml
      schema = JSON.parse Base64.decode(data.content) # jsyaml.load
      if schema.type isnt 'array'
        notification "schema type `#{schema.type}` to do", 'red', true
      form.find('[inject]').append create_item(schema)
      # Append item adder
      adder = $('<div data-type="item"></div>')
        .append($('<label class="fg-secondary">Add item</label>'))
        .append($('<a href="#add" class="prevent-default" data-add="item">add</a>'))
      form.find('[data-type="button"]').before adder
      return # End schema request
    get_schema.always -> form.removeAttr 'disabled'
    return # End load_schema function

  # Populate form
  if form.attr 'data-schema' then load_schema()

  # ADD PROPERTY
  form.on 'click', 'a[data-add="item"]', ->
    form.find('[inject]').append create_item(schema)
    return # End add item event

  # Reset
  form.on 'reset', ->
    # Remove appended items and items adder, reset item index
    form.find('[inject]').empty()
    form.find('[data-type="item"]').remove()
    # Load schema
    if form.attr 'data-schema' then load_schema()
    return # end Reset handler

  # Submit
  form.on 'submit', ->

    # Check user is logged
    if !$('html').hasClass 'logged' or !$('html').hasClass('role-admin')
      notification 'You need to login as `admin`', 'red'
      return

    # Parse FORM
    # Check empty object
    if !Object.keys(form.serializeJSON()) then return
    # Loop fields
    head = []
    rows = []
    # Item DIVs
    form.find('.item').each (i, row) ->
      rows[i] = []
      # Item FIELDS
      $(@).find(':input').each (j, field) ->
        head[j] = $(field).attr 'name'
        rows[i].push $(field).val()
        return # End FIELDS loop
      return # End item DIVs loop
    head_csv = head.join(',')
    rows_csv = (row.join(',') for row in rows).join('\n')

    # Prepare for requests
    path = form.attr('data-document') || form.attr('data-schema')
    # Prepend user folder if repository is forked
    if storage.get("repository.fork")
      path = "user/#{storage.get 'login.user'}/#{path}"
    document_url = "{{ site.github.api_url }}/repos/{{ site.github.repository_nwo }}/contents/_data/#{path}.csv"
    form.attr 'disabled', ''

    # Check if document exist
    get_document = $.get document_url
    get_document.fail (request, status, error) ->
      # File don't exist
      if error is 'Not Found'
        # Encode csv file
        encoded_content = Base64.encode [head_csv, rows_csv].join('\n')
        # Prepare commit
        load =
          message: 'Create document'
          content: encoded_content
        # Commit new file
        notification load.message
        put = $.ajax document_url,
          method: 'PUT'
          data: JSON.stringify load
        put.done -> notification 'Document created', 'green'
        put.always ->
          form.removeAttr 'disabled'
          form.trigger 'reset'
          return
      else form.removeAttr 'disabled'
      return # End file don't exist case

    # File present, ovwrwrite with SHA reference
    get_document.done (data, status) ->
      # Encode csv file
      encoded_content = Base64.encode [Base64.decode(data.content), rows_csv].join('\n')
      # Prepare commit
      load =
        message: 'Edit document'
        sha: data.sha
        content: encoded_content
      # Commit edited file
      notification load.message
      put = $.ajax document_url,
        method: 'PUT'
        data: JSON.stringify load
      put.done -> notification 'Document edited', 'green'
      put.always ->
        form.removeAttr 'disabled'
        form.trigger 'reset'
        return # End request finished
      return # End update file

    return # End SUBMIT

  return # End form loop
{%- capture api -%}
## Document

Manage a document FORM from a schema of `type=array`.  
Needs [document]({{ 'docs/widgets/#document' | absolute_url }}) widget.

**FORM**

- Class `document`
- Attribute `data-schema`: URI-reference of the schema to load (no extension)
{%- endcapture -%}