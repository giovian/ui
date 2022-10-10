#
# PROPERTY inject helper function
# --------------------------------------
get_property = (parent_type, key, value) ->
  nest = switch parent_type
    when 'object' then 'properties'
    when 'array' then 'items[properties]'
    else 'error'
  prepend = "#{nest}[#{slug key}]"
  template_property = get_template '#template-property', prepend
  # Update property title
  template_property.find('summary').prepend document.createTextNode "#{key}"
  # Get property type
  property_type = value?.type || 'string'
  # Update fields
  template_property.find("[name='#{prepend}[type]']").val property_type
  # Get property template
  selected_template = get_template "#template-#{property_type}", prepend
  if property_type is 'integer' then property_type = 'number'
  # Set property values
  for own key, property of value
    # Find inputs ending with [key]
    template_property.find("[name='#{prepend}[#{key}]']").val property
    selected_template.find("[name='#{prepend}[#{key}]']").val property
    # Set boolean selects
    if key in ['required', 'svg'] and property
      selected_template.find("[name='#{prepend}[#{key}]']").val 'true'
    # Check enums
    if key is 'enum' and Array.isArray property
      enum_inject = selected_template.find('[enum-inject]')
      # Loop enum values
      for enum_value in property
        enum_div = get_template '#template-enum', prepend
        input = enum_div.find('input')
        # Reduce the prepend virulence
        input.attr 'name', (i, v) -> v.replace('[[enum][]]', '[enum][]')
        input.attr 'id', (i, v) -> v.replace('[[enum][]]', '[enum][]')
        # Set attributes and values
        input.attr 'data-value-type', property_type
        input.val enum_value
        enum_div.find('label').text enum_value
        enum_inject.append enum_div
  # Append property
  selected_template.find('[class*="flipper"]').each -> flipper @
  inject = template_property.find('[type-inject]')
  inject.attr 'type-inject', property_type
  inject.append selected_template
  return template_property # End property inject

#
# FORM EVENTS
# --------------------------------------
$('form.schema').each (i, element)->
  form = $ element

  # ADD PROPERTY
  form.on 'click', 'a[data-add=property]', ->
    # Prompt property name
    property_name = prompt 'Property name'
    # Inject property
    if property_name
      form
        .find('[properties-inject]')
        .append get_property(form.find('[name="type"]').val(), property_name)
    else $(@).blur()
    return # End add-property

  # ADD ENUM VALUE
  form.on 'click', 'a[data-add=enum]', ->
    # Enum value
    enum_value = prompt 'Enum value'
    # Inject property
    if enum_value
      # Get value type
      type = $(@).parents('[type-inject]').attr 'type-inject'
      # Prepare enum DIV
      enum_div = get_template '#template-enum', $(@).attr('data-prepend')
      input = enum_div.find('input')
      # Reduce the prepend virulence
      input.attr 'name', (i, v) -> v.replace('[[enum][]]', '[enum][]')
      input.attr 'id', (i, v) -> v.replace('[[enum][]]', '[enum][]')
      # Set attributes and values
      input.attr 'data-value-type', (i, v) -> if type is 'integer' then 'number' else type
      input.val enum_value
      enum_div.find('label').text enum_value
      # Append enum DIV
      $(@).parents('details').find('[enum-inject]').append enum_div
    return # End add-property

  # REMOVE PROPERTY
  form.on 'click', 'a[data-remove=property]', ->
    if !confirm "Delete property?"
      $(@).blur()
      return
    $(@).parents('details').remove()
    return

  # MOVE PROPERTY DOWN
  form.on 'click', 'a[data-down=property]', ->
    details = $(@).parents 'details'
    details.insertAfter details.next()
    return

  # MOVE PROPERTY UP
  form.on 'click', 'a[data-up=property]', ->
    details = $(@).parents 'details'
    details.insertBefore details.prev()
    return

  # REMOVE ENUM VALUE
  form.on 'click', 'a[data-remove=enum]', -> $(@).parents('[data-type]').remove()

  # Change schema type
  form.on 'change', 'select[name=type]', ->
    inject = form.find('[inject]')
    inject.empty().append get_template "#template-#{$(@).val()}"
    inject.attr 'inject', $(@).val()
    return # End schema type change

  # Change property type
  form.on 'change', 'select[name*=type]', ->
    # Get parent
    parent = $(@).attr('name').replace '[type]', ''
    selected_template = get_template "#template-#{$(@).val()}", parent
    # Reset TABs and append on property [type-inject]
    flipper selected_template.find('[class*="flipper"]')
    type_inject = $(@).parents('details').find('[type-inject]')
    type_inject.empty().append selected_template
    type_inject.attr 'type-inject', $(@).val()
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
    # Reset schema type select
    form.find('select[name=type]').prop 'selectedIndex', 0
    # Reset inject item properties forms
    form.find('[properties-inject]').empty()
    # Load schema
    if form.attr 'data-file' then form_load_schema form.attr('data-file'), 'schema'
    return # end Reset handler

  # Submit
  form.on 'submit', ->
  
    # Check user is admin
    if !$('html').hasClass 'role-admin'
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
        put.done (data) ->
          notification 'Schema created', 'green'
          stored_data =
            sha: data.content.sha
            content: encoded_content
          # Save data for the future
          cache schema_url, stored_data
          return # End create schema
        put.always -> form.removeAttr 'disabled'
      else
        form.removeAttr 'disabled'
        # Reset eventual Document
        $('body').find("form.document[data-file='#{path}']").trigger 'reset'
      return # End new file
  
    # File present, overwrite with sha reference
    get_schema.done (data) ->
      data = cache schema_url, data
      load =
        message: 'Edit schema'
        sha: data.sha
        content: encoded_content
      # Commit edited file
      notification load.message
      put = $.ajax schema_url,
        method: 'PUT'
        data: JSON.stringify load
      put.done (data) ->
        notification 'Schema edited', 'green'
        # Store data for the future
        stored_data =
          sha: data.content.sha
          content: encoded_content
        # Save data for the future
        cache schema_url, stored_data
        return # End schema update
      put.always ->
        form.removeAttr 'disabled'
        # Reset eventual Document
        $('body').find("form.document[data-file='#{path}']").trigger 'reset'
        return # End new schema PUT
      return # End overwrite
  
    return # End submit handler

  return # end FORM loop
{%- capture api -%}
## Schema

Manage a schema FORM of `type=array`.  
Needs [schema]({{ 'docs/widgets/#schema' | absolute_url }}) widget.

**FORM**

- Class `schema`
- Attribute `data-file`: URI-reference of the schema to load (no extension)
{%- endcapture -%}