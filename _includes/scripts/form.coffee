#
# Initialize serializeJSON
# --------------------------------------
$.serializeJSON.defaultOptions.skipFalsyValuesForTypes = 'string,number,boolean,date'.split ','

# Get file url from data-file FORMs attribute
url_from_datafile = (form) ->
  path = form.attr 'data-file'
  if path
    if form.hasClass 'document' # Prepend user folder if repository is forked
      if storage.get "repository.fork"
        url = "user/{{ site.github.owner_name }}/#{path}"
    if form.hasClass 'schema'
      url = "#{path}.schema.json"
  return "#{github_api_url}/contents/_data/#{url || path}"

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
  # Get schema from storage and decode content
  schema_data = cache "#{form.attr 'data-file'}.schema.json"
  schema = JSON.parse Base64.decode schema_data.content
  item = $ '<div/>', {class: 'item'}
  # Loop items
  items = switch schema.type
    when 'array' then schema.items.properties
    when 'object' then schema.properties
  # Loop items properties
  for own key, value of items
    # Default variabiles
    field = $ '<input/>', {type: 'text'}
    field.attr 'autocomplete', value.autocomplete || 'off'
    if value.required then field.attr 'required', 'required'
    data_type = 'string'

    # Check enum SELECT
    if value.enum?.length
      field = $ '<select/>', {class: value.class? || ''}
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
            $ '<option value="false">False</option>'
            $ '<option value="true">True</option>'
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
    # Selects don't need labe[for]
    if field.prop('tagName') isnt 'SELECT' then label.attr 'for', "#{key}-#{unique_id}"
    # Prepare container div[data-type]
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

    # Check SVG
    if value.svg
      # Load SVG
      item.append get_template "#template-svg"
      # bind svg file change event
      field.off("change").on "change", (e) ->
        image_url = "#{$(e.target).attr 'name'}_#{e.target.value}.svg"
        # Call the 'svg_injected' function at svg loaded
        item
          .find('[data-type=svg]')
          .load("{{ site.baseurl }}/assets/images/#{image_url}?t=#{+new Date()}", null, () -> svg_injected @)
        return # End onChange SVG-linked property
      # Load default SVG
      field.trigger 'change'

  # End properties loop
  return item # End create_item

# SVG injected
svg_injected = (div) ->
  svg = $ div

  # Loop color inputs for default values and change handlers
  svg.parents('form.document').find('input[type=color]').each ->
    # Color change handler
    $(@).on "change", (e) ->
      # Set selected color on Fill
      svg
        .find ".#{$(e.target).attr 'name'}[stroke=none]"
        .attr 'fill', $(e.target).val()
      # Set selected color on Stroke
      svg
        .find ".#{$(e.target).attr 'name'}[fill=none]"
        .attr 'stroke', $(e.target).val()
      return # End colors handler

    # Initial colorization
    $(@).trigger 'change'

    return # End color inputs loop

  # Loop text inputs for default text and change handler
  svg.parents('form.document').find('input[type=text]').each ->
    # Set string on Text tags
    $(@).on "change", (e) ->
      svg
        .find "text.#{$(e.target).attr 'name'}"
        .text $(e.target).val()
      return

    # Initial colorization
    $(@).trigger 'change'

    return # End color inputs loop

  return # End SVG injected handler

#
# CREATE SCHEMA FORM
# --------------------------------------
create_schema_form = (form, schema) ->
  # Inject schema type template
  form.find('[inject]').empty().append get_template "#template-#{schema.type}"
  # Populate fields
  form.find('[name="title"]').val schema.title
  form.find('[name="description"]').val schema.description
  form.find('[name="$id"]').val schema['$id']
  form.find('[name="type"]').val schema.type
  items = switch schema.type
    when 'array' then schema.items.properties
    when 'object' then schema.properties
  for own key, value of items
    form
      .find('[properties-inject]')
      .append get_property(schema.type, key, value)
  return # End Schema Form

#
# CREATE DOCUMENT FORM
# --------------------------------------
create_document_form = (form, schema) ->

  # Title and description
  if schema.title then form.find('span.form-title').text schema.title
  if schema.description then form.find('h3').after $ '<p/>', {text: schema.description}

  # Remove Add item button and create item
  form.find('[data-type="item"]').remove()
  form.find('[inject]').empty().append form_create_item form

  # Append item adder only for array type schemas
  if schema.type is 'array'
    form
      .find('[data-type="button"]')
      .before get_template '#template-add-item'

  # Check if is an existent object instance
  if schema.type is 'object'
    document_url = "#{url_from_datafile form}.json"
    check_document = $.get document_url
    check_document.done (data) ->
      data = cache document_url, data
      obj = JSON.parse Base64.decode(data.content)
      # Fill form fields if present
      # TO DO: nested objects
      form.find('[name][id]').each ->
        input = $ @
        name = input.attr 'name'
        if obj[name]? then input.val obj[name]
        return
      return

  # Required asterix
  form.find('input[required]').each -> $(@).prev('label').append '<sup class="fg-secondary"> *</sup>'

  return # End create document form

#
# FORM LOAD SCHEMA function for schema and document forms
# --------------------------------------
form_load_schema = (path, classe) ->
  forms = if classe then $("form.#{classe}[data-file='#{path}']") else $("form[data-file='#{path}']")
  schema_url = "#{github_api_url}/contents/_data/#{path}.schema.json"
  forms.attr 'disabled', ''

  # Request schema file
  get_schema = $.get schema_url
  get_schema.done (data) ->
    data = cache schema_url, data
    # Parse schema
    schema = JSON.parse Base64.decode(data.content)
    # Create the FORM
    forms.each ->
      if $(@).hasClass 'schema' then create_schema_form $(@), schema
      if $(@).hasClass 'document' then create_document_form $(@), schema
    return # End get_schema
  get_schema.always -> forms.removeAttr 'disabled'
  get_schema.fail (request) ->
    # Schema file not present
    if request.status is 404
      # Form schema load default type template
      forms.each ->
        if $(@).hasClass 'schema'
          $(@).find('[inject]').empty().append get_template "#template-#{$(@).find('[name=type]').val()}"
        # For document show error
        if $(@).hasClass 'document'
          $(@).find('h3').after $ '<p/>',
            class: 'red'
            text: "No schema present: #{path}.schema.json"
        return # End forms loop
      notification 'File not present, will be created on Save'
    return

  return # End load_schema function

#
# ACTIVATION function
# --------------------------------------
$('form').each ->
  form = $ @

  # Update range output
  form.find("input[type=range]").each -> input_range_enable $(@)

  #
  # FORM EVENTS
  # --------------------------------------
  # FORM Change
  form.on "change", ':input', (e) ->
    # console.log $(e.target).attr 'name'
    return

  #
  # SUBMIT and RESET
  # --------------------------------------

  # Reset
  form.on "reset", ->
    form.find(':input').blur()

    # Reset range output value
    # Default delay is 0ms, "immediately" i.e. next event cycle, actual delay may be longer
    setTimeout -> form.find("input[type=range]").trigger "input"

    return # End reset handler

  # Submit
  form.on "submit", ->
    form.find(':input').blur()
    console.log form.serializeJSON()

  # View button click
  form.on 'click', '[data-type="button"] [type="button"]', ->
    form.find(':input').blur()
    console.log form.serializeJSON()

  return # end FORM loop

#
# ACTIVATION SCHEMAs and DOCUMENTs
# --------------------------------------
$('form.document[data-file], form.schema')
  .toArray()
  .map (e) -> $(e).attr 'data-file'
  .filter (e, i, a) -> i == a.indexOf e
  .map (e) -> form_load_schema e

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