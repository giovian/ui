#
# TEMPLATE helper function
# --------------------------------------
get_template = (id, prepend) ->
  template = $ $(id).clone().prop('content')
  if prepend
    # Update labels [for]
    template.find('label[for]').each -> $(@).attr 'for', (i, val) -> "#{prepend}[#{val}]"
    # Update inputs [name]
    template.find(':input[name]').attr 'name', (i, val) -> "#{prepend}[#{val}]"
    # Update switches
    template.find('a[data-add="enum"]').attr 'data-prepend', prepend
  return template

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
        input.attr 'data-value-type', (i, v) -> if property_type is 'integer' then 'number' else property_type
        input.val enum_value
        enum_div.find('label').text enum_value
        enum_inject.append enum_div
  # Append property
  template_property.find('[type-inject]').append selected_template
  return template_property # End property inject

#
# ACTIVATION function
# --------------------------------------
$('form.schema').each ->
  form = $ @

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
      # Populate fields
      form.find('[name="title"]').val schema.title
      form.find('[name="$id"]').val schema['$id']
      form.find('[name="description"]').val schema.description
      # Loop items.properties
      for own key, value of schema.items.properties
        form.find('[properties-inject]').append get_property(key, value)
      # Loop tab DIVs
      form.find('div[tab-container]').each ->
        # Reveal first TAB
        $(@).find('a[data-tab]:first').trigger 'click'
        # Check for enum fields
        enum_link = $(@).find 'a[data-tab="enum"]'
        $(@).find('div[data-tab="enum"] div[enum-inject]').each ->
          # If enum values are present, reveal enum tab
          if !$(@).is(':empty') then enum_link.trigger 'click'
          return
        return
      return # Form is populated
    get_schema.fail -> form.find('[name="$id"]').val form.attr('data-schema')
    get_schema.always -> form.removeAttr 'disabled'
    return # End load_schema function

  # Populate form
  if form.attr 'data-schema' then load_schema()

  #
  # CREATE SCHEMA
  # --------------------------------------

  # ADD PROPERTY
  form.on 'click', 'a[data-add="property"]', ->
    # Prompt property name
    property_name = prompt 'Property name'
    # Inject property
    if property_name
      form.find('[properties-inject]').prepend get_property(property_name)
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
      enum_div = get_template '#template-enum', (@).attr('data-prepend')
      input = enum_div.find('input')
      # Reduce the prepend virulence
      input.attr 'name', (i, v) -> v.replace('[[enum][]]', '[enum][]')
      # Set attributes and values
      input.attr 'data-value-type', (i, v) -> if type is 'integer' then 'number' else type
      input.val enum_value
      enum_div.find('label').text enum_value
      enum_inject.prepend enum_div
      # Append enum DIV
      $(@).parents('details').find('[enum-inject]').prepend enum_div
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
    if form.attr 'data-schema' then load_schema()
    return # end Reset handler

  # Submit
  form.on 'submit', ->

    # Check user is logged
    if !$('html').hasClass('logged') or !$('html').hasClass('role-admin')
      notification 'You need to login as `admin`', 'red'
      return

    # Write data
    encoded_content = Base64.encode JSON.stringify(form.serializeJSON(), null, 2)
    path = form.find('[name="$id"]').val()
    # Prepend user folder if repository is forked
    if storage.get("repository.fork")
      path = "user/#{storage.get 'login.user'}/#{path}"
    schema_url = "{{ site.github.api_url }}/repos/{{ site.github.repository_nwo }}/contents/_data/#{path}.schema.json"
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
      else form.removeAttr 'disabled'
      return # End new file

    # File present, overwrite with sha reference
    get_schema.done (data, status) ->
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
        $('body').find("form.document[data-schema=#{form.find('[name="$id"]').val()}]")
          .trigger 'reset'
      return # End overwrite

    return # End submit handler

  return # end FORM loop
{%- capture api -%}
## Schema

Manage a schema FORM of `type=array`.  
Needs [schema]({{ 'docs/widgets/#schema' | absolute_url }}) widget.

**FORM**

- Class `schema`
- Attribute `data-schema`: URI-reference of the schema to load (no extension)
{%- endcapture -%}