#
# Initialize serializeJSON
# --------------------------------------
$.serializeJSON.defaultOptions.skipFalsyValuesForTypes = 'string,number,boolean,date'.split ','

#
# TEMPLATE helper function
# --------------------------------------
get_template = (id, prepend) ->
  template = $ $(id).clone().prop('content')
  if prepend
    # Update labels [for]
    template.find('label[for]').each ->
      $(@).attr 'for', (i, val) -> "#{prepend}[#{val}]"
    # Update inputs [name]
    template.find(':input[name]').attr 'name', (i, val) -> "#{prepend}[#{val}]"
    template.find(':input[name]').attr 'id', (i, val) -> "#{prepend}[#{val}]"
    # Update switches
    template.find('a[data-add="enum"]').attr 'data-prepend', prepend
  return template

#
# Enable RANGE OUTPUT
# --------------------------------------
input_range_enable = (range) ->
  $(range).on "input", (e) -> $(e.target).next("output").val $(e.target).val()
  # Initial update
  $(range).trigger "input"
  return # end Range loop

#
# Document form CREATE ITEM function
# --------------------------------------
form_create_item = (form) ->
  unique_id = +new Date()
  schema_data = get_github_api_data "#{form.attr 'data-file'}.schema.json"
  schema = JSON.parse Base64.decode schema_data.content
  item = $ '<div/>', {class: 'item'}
  # Loop items properties
  for own key, value of schema.items.properties
    # Default variabiles
    field = $ '<input/>', {type: 'text'}
    field.attr 'autocomplete', value.autocomplete || 'off'
    if value.required then field.attr 'required', 'required'
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
        # Decimal values
        if value.type is 'number'
          field.attr 'step', 'any'
        # Range type
        if value.format is 'range'
          data_type = 'range'
          field.attr 'type', 'range'
      when 'boolean'
        data_type = 'select'
        field = $('<select class="inline" data-value-type="boolean"></select>')
          .append [
            $ '<option value="true">True</option>'
            $ '<option value="false">False</option>'
          ]
      else notification "Property type `#{value.type}` to do", 'red'

    # Complete field attributes
    field.attr 'name', "#{key}"
    field.attr 'id', "#{key}-#{unique_id}"
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
        field.val date_iso()
      else field.val value.default
    # Prepare elements
    label = $ '<label/>', {text: value.title || key}
    if field.prop('tagName') isnt 'SELECT' then label.attr 'for', "#{key}-#{unique_id}"
    div = $ '<div/>', {'data-type': data_type}
    # Append label and field to DIV, add whitespace for inline SELECTs
    div.append [label, " ", field]
    # Append output element for RANGE
    if value.format is 'range'
      div.append $ '<output/>', {for: key}
      input_range_enable field
    # Append description SPAN, prepend a space for inline cases
    if value.description then div.append [' ', $ '<span/>', {text: value.description}]
    # Append DIV to ITEM
    item.append div
  # End properties loop
  return item # End create_item

#
# FORM LOAD SCHEMA function for schema and document fomrs
# --------------------------------------
form_load_schema = (form) ->
  path = form.attr 'data-file'
  # Compile the file path field
  form.find('[name="$id"]').val path
  schema_url = "#{github_api_url}/contents/_data/#{path}.schema.json"
  form.attr 'disabled', ''

  # Request schema file
  get_schema = $.get schema_url
  get_schema.done (data, status) ->
    data = cache data, schema_url
    # Parse schema
    schema = JSON.parse Base64.decode(data.content)
    if form.hasClass 'schema'
      # Inject schema type template
      form.find('[inject]').empty().append get_template "#template-#{schema.type}"
      # Populate fields
      form.find('[name="title"]').val schema.title
      form.find('[name="$id"]').val schema['$id']
      form.find('[name="description"]').val schema.description
      form.find('[name="type"]').val schema.type
      if schema.type is 'array'
        # Loop items.properties
        for own key, value of schema.items.properties
          form
            .find('[properties-inject]')
            .append get_property(schema.type, key, value)
      if schema.type is 'object'
        # Loop object properties
        for own key, value of schema.properties
          form
            .find('[properties-inject]')
            .append get_property(schema.type, key, value)
    if form.hasClass 'document'
      form.find('[inject]').append form_create_item form
      # Append item adder
      form.find('[data-type="button"]').before get_template '#template-add-item'
    return # Form is populated
  get_schema.always -> form.removeAttr 'disabled'
  get_schema.fail (request, status, error) ->
    if request.status is 404
      if form.hasClass 'schema'
        form.find('[inject]').empty().append get_template "#template-#{form.find('[name=type]').val()}"
      if form.hasClass 'document'
        form.find('h3').after $ '<p/>',
          class: 'red'
          text: "No schema present: #{path}.schema.json"
      notification 'File not present, will be created on Save'
    return
  return # End load_schema function

#
# Load Schema and Document for CSV
# --------------------------------------
load_schema_document = (el, callback) ->
  element = $ el
  element.attr 'disabled', ''

  # Get file names
  document_url = "#{github_api_url}/contents/_data/#{element.attr 'data-file'}.csv"
  schema_url = "#{github_api_url}/contents/_data/#{element.attr 'data-file'}.schema.json"
  
  # Load schema
  get_schema = $.get schema_url
  get_schema.done (data) ->
    data = cache data, schema_url
    # Load document
    get_document = $.get document_url
    get_document.done (data) ->
      data = cache data, document_url
      callback element, data
      return # End get document
    get_document.always -> element.removeAttr 'disabled'
    return # End schema file load
  get_schema.fail -> element.removeAttr 'disabled'

  return # End CSV tables loop

#
# ACTIVATION function
# --------------------------------------
$('form').each ->
  form = $ @

  # Update range output
  form.find("input[type=range]").each -> input_range_enable $(@)

  # Required asterix
  form.find('input[required]').each -> $(@).prev('label').append '*'

  #
  # FORM EVENTS
  # --------------------------------------
  # FORM Change
  form.on "change", ':input', (e) ->
    # console.log $(e.target).attr 'name'
    return

  # Reset
  form.on "reset", ->

    # Reset range output value
    # Default delay is 0ms, "immediately" i.e. next event cycle, actual delay may be longer
    setTimeout -> form.find("input[type=range]").trigger "input"

    return # end Reset handler

  # Submit
  form.on "submit", -> console.log form.serializeJSON()

  return # end FORM loop
{%- capture api -%}
## Form

Basic functions of the FORM.  
Manage reset and submit events, range and required fields, configure `serializeJSON`.

```html
<form class='prevent-default'>
<!-- Fields -->
</form>
```
{%- endcapture -%}