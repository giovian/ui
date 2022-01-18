# Reset FORMs TABs
reset_form_tabs = (tab) ->
  if $(tab).find('div[data-tab="enum"] div[enum-inject]:not(:empty)').length then index=1 else index=0
  reset_tabs tab, index
  return

#
# PROPERTY inject helper function
# --------------------------------------
get_property = (key, value) ->
  prepend = "items[properties][#{slug key}]"
  template_property = get_template '#template-property', prepend
  # Update property title
  template_property.find('summary').prepend document.createTextNode "#{key}"
  # Get property type
  property_type = value?.type || 'string'
  template_property.find("[name='#{prepend}[type]']").val property_type
  selected_template = get_template "#template-#{property_type}", prepend
  # Set property values
  for own key, property of value
    selected_template.find("[name$='[#{key}]']").val property
    # Check enums
    if key is 'enum' and Array.isArray property
      enum_inject = selected_template.find('[enum-inject]')
      # Loop enum values
      for enum_value in property
        enum_div = get_template '#template-enum', prepend
        input = enum_div.find('input')
        # Reduce the prepend virulence
        input.attr 'name', (i, v) -> v.replace('[[enum][]]', '[enum][]')
        # Set attributes and values
        input.attr 'data-value-type', (i, v) ->
          if property_type is 'integer' then 'number' else property_type
        input.val enum_value
        enum_div.find('label').text enum_value
        enum_inject.append enum_div
  # Append property
  selected_template.find('[tab-container]').each -> reset_form_tabs @
  template_property.find('[type-inject]').append selected_template
  return template_property # End property inject

#
# ACTIVATION function
# --------------------------------------
$('form.schema').each ->
  form = $ @

  # Populate form
  if form.attr 'data-schema' then form_load_schema form

  #
  # EVENTS
  # --------------------------------------

  # ADD PROPERTY
  form.on 'click', 'a[data-add="property"]', ->
    # Prompt property name
    property_name = prompt 'Property name'
    # Inject property
    if property_name
      form.find('[properties-inject]').append get_property(property_name)
    return # End add-property

  # ADD ENUM VALUE
  form.on 'click', 'a[data-add="enum"]', ->
    # Enum value
    enum_value = prompt 'Enum value'
    # Inject property
    if enum_value
      # Get value type
      type = $(@).parents('[data-type]').attr 'data-type'
      # Prepare enum DIV
      enum_div = get_template '#template-enum', $(@).attr('data-prepend')
      input = enum_div.find('input')
      # Reduce the prepend virulence
      input.attr 'name', (i, v) -> v.replace('[[enum][]]', '[enum][]')
      # Set attributes and values
      input.attr 'data-value-type', (i, v) -> if type is 'integer' then 'number' else type
      input.val enum_value
      enum_div.find('label').text enum_value
      # Append enum DIV
      $(@).parents('details').find('[enum-inject]').append enum_div
    return # End add-property

  # REMOVE PROPERTY
  form.on 'click', 'a[data-remove="property"]', -> $(@).parents('details').remove()

  # REMOVE ENUM VALUE
  form.on 'click', 'a[data-remove="enum"]', -> $(@).parents('[data-type]').remove()

  # Change property type
  form.on 'change', 'select[name*="type"]', ->
    # Get parent
    parent = $(@).attr('name').replace '[type]', ''
    selected_template = get_template "#template-#{$(@).val()}", parent
    # Reset TABs and append on property [type-inject]
    reset_tabs selected_template.find('[tab-container]')
    $(@).parents('details').find('[type-inject]').empty().append selected_template
    return # End property type change

  #
  # FORM EVENTS
  # --------------------------------------
  # FORM Change
  form.on 'change', ':input', (e) ->
    # console.log $(e.target).attr 'name'
    return

  # Reset
  form.on 'reset', ->
    # Reset .create-schema forms
    form.find('[properties-inject]').empty()
    # Load schema
    if form.attr 'data-schema' then form_load_schema form
    return # end Reset handler

  # Submit
  form.on 'submit', ->

    # Check user is logged
    if !login.logged_admin()
      notification 'You need to login as `admin`', 'red'
      return

    # Write data
    encoded_content = Base64.encode JSON.stringify(form.serializeJSON(), null, 2)
    path = form.find('[name="$id"]').val()
    schema_url = "#{github_api_url}/contents/_data/#{path}.schema.json"
    notification 'Check if file exist'
    form.attr 'disabled', ''

    # Check if file already exist
    get_schema = $.get schema_url
    get_schema.fail (request, status, error) ->
      # Schema not found
      if error is 'Not Found'
        load =
          message: 'Create schema'
          content: encoded_content
        # Commit new file
        notification load.message
        put = $.ajax schema_url,
          method: 'PUT'
          data: JSON.stringify load
        put.done -> notification 'Schema created', 'green'
        put.always -> form.removeAttr 'disabled'
      else
        form.removeAttr 'disabled'
        # Reset eventual Document
        $('body').find("form.document[data-schema='#{path}']").trigger 'reset'
      return # End new file

    # File present, overwrite with sha reference
    get_schema.done (data) ->
      data = cache data, schema_url
      load =
        message: 'Edit schema'
        sha: data.sha
        content: encoded_content
      # Commit edited file
      notification load.message
      put = $.ajax schema_url,
        method: 'PUT'
        data: JSON.stringify load
      put.done -> notification 'Schema edited', 'green'
      put.always ->
        form.removeAttr 'disabled'
        # Reset eventual Document
        $('body').find("form.document[data-schema='#{path}']").trigger 'reset'
      return # End overwrite

    return # End submit handler

  return # end FORM loop
{%- capture api -%}
## Schema

Manage a schema FORM of `type=array`.  
Needs [schema]({{ 'docs/widgets/#schema' | absolute_url }}){: remote=''} widget.

**FORM**

- Class `schema`
- Attribute `data-schema`: URI-reference of the schema to load (no extension)
{%- endcapture -%}