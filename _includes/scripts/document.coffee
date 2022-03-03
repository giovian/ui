update_csv = (document_file, data) ->

  # Update eventual CSV table
  $(".csv-table[data-file='#{document_file}']").each ->
    fill_table $(@), data
    return # End tables update

  # Update eventual CSV blocks
  $(".csv-blocks[data-file='#{document_file}']").each ->
    fill_blocks $(@), data
    return # End blocks update

  # Update eventual CSV calendar
  $(".csv-calendar[data-file='#{document_file}']").each ->
    fill_calendar $(@), data
    return # End blocks update

  return # End updates tablesand blocks

#
# Loop Document FORMs
# --------------------------------------
$('form.document[data-file]').each ->
  form = $ @
  path = form.attr 'data-file'
  # Prepend user folder if repository is forked
  if storage.get "repository.fork"
    path = "user/#{storage.get 'login.user'}/#{path}"

  # Initial form population
  form_load_schema form

  # ADD PROPERTY
  form.on 'click', 'a[data-add="item"]', ->
    form.find('[inject]').append form_create_item form
    return # End add item event

  # Reset
  form.on 'reset', ->
    # Remove appended items and items adder, reset item index
    form.find('[inject]').empty()
    form.find('[data-type="item"]').remove()
    form.find('[name=index]').val ''
    # If form was editing from a csv TABLE, reset class
    $(document).find("table.csv-table[data-file='#{form.attr 'data-file'}'] tr[disabled]").removeAttr 'disabled'
    # Load schema
    if form.attr 'data-file' then form_load_schema form
    return # end Reset handler

  # Submit
  form.on 'submit', ->

    # Check user is logged
    if !$('html').hasClass 'role-admin'
      notification 'You need to login as `admin`', 'red'
      return

    # Parse FORM
    # Check empty object
    if !Object.keys(form.serializeJSON()).length then return
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
    head_csv = head.join ','
    rows_csv = (row.join(',') for row in rows).join '\n'

    # Prepare for requests
    document_url = "#{github_api_url}/contents/_data/#{path}.csv"
    form.attr 'disabled', ''

    # Check if document exist
    get_document = $.get document_url
    get_document.fail (request, status, error) ->
      # File don't exist
      if error is 'Not Found'
        # Prepare commit
        load =
          message: 'Create document'
          content: Base64.encode [head_csv, rows_csv].join('\n')
        # Commit new file
        notification load.message
        put = $.ajax document_url,
          method: 'PUT'
          data: JSON.stringify load
        put.done (data) ->
          notification 'Document created', 'green'
          # Save new SHA for future deletes
          stored_data =
            sha: data.content.sha
            content: load
          # Save data for the future
          set_github_api_data document_url, stored_data
          # Update other elements
          update_csv "#{form.attr 'data-file'}", stored_data
          form.trigger 'reset'
          return # End document created
        put.always -> form.removeAttr 'disabled'
      else form.removeAttr 'disabled'
      return # End file don't exist case

    # File present, overwrite with SHA reference
    get_document.done (data) ->
      data = cache data, document_url
      # Prepare old array
      csv_array = Base64.decode(data.content).split '\n'
      csv_array[0] = head_csv
      # Encode csv file, append or update row
      if !form.find('[name=index]').val()
        csv_array.push rows_csv
        encoded_content = Base64.encode csv_array.join('\n')
      else
        # Update row
        csv_array[+form.find('[name=index]').val()] = rows_csv
        encoded_content = Base64.encode csv_array.join('\n')
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
      put.done (data) ->
        notification 'Document edited', 'green'
        # Save new SHA for the future
        stored_data =
          sha: data.content.sha
          content: encoded_content
        set_github_api_data document_url, stored_data
        # Update other elements
        update_csv "#{form.attr 'data-file'}", stored_data
        form.trigger 'reset'
        return # End document update
      put.always -> form.removeAttr 'disabled'
      return # End update file

    return # End SUBMIT

  return # End form loop
{%- capture api -%}
## Document

Manage a document FORM from a schema of `type=array`.  
Needs [document]({{ 'docs/widgets/#document' | absolute_url }}) widget.

**FORM**

- Class `document`
- Attribute `data-file`: URI-reference of the schema to load (no extension)
{%- endcapture -%}