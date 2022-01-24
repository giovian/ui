#
# Fill CSV TABLE function
# --------------------------------------
fill_table = (data, schema, table) ->

  # Get sort
  id = [$('body').attr('page-title'), $('table[csv-table]').index(table)].join '|'
  table.attr 'data-sort', (i, v) -> storage.get("sort.#{id}") || v
  # Create header
  csv = Base64.decode(data.content).split '\n'
  headers = csv.shift().split ','
  # Set filter colspan plus #count, plus links
  filter = table.find 'thead.filter'
  filter.find('th').attr 'colspan', headers.length + 2
  # Count header (empty from loading)
  header = table.find 'thead:not(.filter)'
  header.find('#count span').text csv.length
  header.find('#count').css 'width', "#{csv.length.toString().length+2}em"
  header.find('th:not(#count)').remove()
  # Apply family for sort links
  apply_family()

  # Loop headers and populate filter select
  for head in headers
    header.find('tr').append "<th id='#{head}'>#{head}</th>"
    filter.find('select').append $ '<option/>', {value: head, text: head}
  # Edit and delete links column
  header.find('tr').append $ '<th/>'

  # Reset if already populated
  table.find('tbody').empty()
  # Rows loop
  for row_data, j in csv
    # Create row
    row = $('<tr/>').append "<td>#{j+1}</td>"
    # Loop row values
    for value, i in row_data.split ','
      value_properties = schema.items.properties[headers[i]]
      content = value
      # Apply datetime to row
      if value_properties.format is 'date' and value
        datetime row.attr 'datetime', value
      # Append cell
      row.append $ '<td/>',
        'data-value-type': value_properties.type
        headers: headers[i]
        text: content

    # End row loop, Edit remove links
    row.append get_template '#template-service-links-cell'
    # Append row
    if table.attr('data-sort') is 'up'
      table.find('tbody').append row
    else table.find('tbody').prepend row

  # End file loop
  # Check filter saved state
  if storage.get "filters.#{id}"
    [selected_index, input_value] = storage.get("filters.#{id}").split '|'
    filter.find('select[name=column]').prop 'selectedIndex', selected_index
    filter.find('input[name=value]').val input_value
    filter.find('input[name=value]').trigger 'input'
  # Update borders
  hide_last_borders table

  return # Table populated

# Hide last borders
hide_last_borders = (table) ->
  table.find('tr').removeClass 'no-border'
  # Remove bottom border from last visible row and thead if no match
  table.find('tr:not(.hidden):last').addClass 'no-border'
  if !table.find('tbody tr:not(.hidden)').length
    table.find('thead:last-of-type tr').addClass 'no-border'
  return

#
# Load CSV File
# --------------------------------------
load_csv_table = (element) ->
  table = $ element
  table.attr 'disabled', ''
  # Get file names
  csv_file = "#{table.attr 'data-file'}.csv"
  schema_file = csv_file.replace '.csv', '.schema.json'

  # Load schema and CSV
  schema_url = "#{github_api_url}/contents/_data/#{schema_file}"
  get_schema = $.get schema_url
  get_schema.done (data) ->
    data = cache data, schema_url
    # Decode and store schema
    schema = JSON.parse Base64.decode(data.content)
    table.data 'schema_json', schema
    # Load document file
    document_url = "#{github_api_url}/contents/_data/#{csv_file}"
    get_csv = $.get document_url
    # Fill table
    get_csv.done (data) ->
      data = cache data, document_url
      fill_table data, schema, table
      return # End get_csv
    get_csv.always -> table.removeAttr 'disabled'
    return # End schema file loaded
  get_schema.fail -> table.removeAttr 'disabled'

  return # End CSV tables loop

#
# CSV TABLEs loop
# --------------------------------------
$('table[csv-table][data-file!=""]').each -> load_csv_table @

#
# Events
# --------------------------------------

# Filter event
$('.filter').on 'input', 'select[name=column], input[name=value]', ->
  # Get elements
  filter = $(@).parents '.filter'
  table = filter.parents 'table'
  select = filter.find 'select[name=column]'
  # Get values
  selected_index = select.prop 'selectedIndex'
  column = select.val()
  value = filter.find('input[name=value]').val()
  # Save state in storage
  id = [
    $('body').attr('page-title')
    $('table[csv-table]').index table
  ].join '|'
  if selected_index isnt 0 or value isnt ''
    storage.assign 'filters', {"#{id}": "#{selected_index}|#{value}"}
  else storage.clear "filters.#{id}"
  # Reset from last filter
  table.find('tbody tr').removeClass 'hidden'
  table.find('#count span').text table.find('tbody tr').length

  if !value then return
  found = 0
  # Hide rows without a match in cells
  table.find("td[headers='#{column}']").each ->
    if !$(@).text().includes value
      $(@).parents('tr').addClass 'hidden'
    else found++
    return # End cells loop

  hide_last_borders table

  # Update found counter
  table.find('#count span').text found
  return # End filter event

# Sort event
$('table[csv-table][data-file!=""]').on 'click', '#count a', ->
  link = $ @
  table = link.parents 'table'
  tbody = table.find 'tbody'
  id = [$('body').attr('page-title'), $('table[csv-table]').index(table)].join '|'
  if link.attr('href') is '#up'
    table.attr 'data-sort', 'down'
    # Save sort in storage
    storage.assign 'sort', {"#{id}": 'down'}
  else
    table.attr 'data-sort', 'up'
    storage.clear "sort.#{id}"
  tbody.find('tr').each -> tbody.prepend $ @
  # Update bottom borders
  hide_last_borders table
  # Update sort links visibility
  apply_family()
  return # End sort event

# Delete event
$(document).on 'click', "[csv-table] a[href='#delete']", ->
  link = $ @
  row = link.parents 'tr'
  table = row.parents 'table[csv-table]'
  index = +row.children('td:first-child').text()
  row.addClass 'orange'
  if !confirm "Delete row #{index}?"
    row.removeClass 'orange'
    return
  # delete element `index` in csv array
  document_file = table.attr 'data-file'
  document_url = "#{github_api_url}/contents/_data/#{document_file}.csv"
  stored_data = storage.get('github_api')[document_url].data
  # Retrieve array and remove row
  csv = Base64.decode(stored_data.content).split '\n'
  csv.splice index, 1
  # Store new content for future deletes
  stored_data.content = Base64.encode csv.join '\n'
  # Prepare commit
  load =
    message: 'Delete entry'
    sha: stored_data.sha
    content: stored_data.content
  # Commit edited file
  notification load.message
  table.attr 'disabled', ''
  put = $.ajax document_url,
    method: 'PUT'
    data: JSON.stringify load
  put.done (data) ->
    notification 'Entry deleted', 'green'
    # Save new SHA for future deletes
    stored_data.sha = data.content.sha
    storage.assign 'github_api', {"#{document_url}":
      data: stored_data
    }
    # Update table and eventual blocks
    update_tables_blocks load, table.data('schema_json'), document_file
    return # End document update
  put.always -> table.removeAttr 'disabled'

  return # End delete event

# Edit event
$(document).on 'click', "[csv-table] a[href='#edit']", ->
  link = $ @
  row = link.parents 'tr'
  index = +row.children('td:first-child').text()
  # Retrieve data
  table = row.parents 'table[csv-table]'
  document_file = table.attr 'data-file'
  document_url = "#{github_api_url}/contents/_data/#{document_file}.csv"
  stored_data = storage.get('github_api')[document_url].data
  csv = Base64.decode(stored_data.content).split '\n'
  values = csv[index].split ','
  head = csv[0].split ','
  # Apply highlight class
  table.find('tr').removeClass 'orange'
  row.addClass 'orange'
  # Check Document FORM is present
  form = $ $(document).find("form.document[data-schema='#{document_file}']")[0]
  if !Object.keys(form).length
    alert "Include 'widgets/document.html' form in the page"
    row.removeClass 'orange'
    return # End delete event
  # Update edit index
  form.find('[name=index]').val index
  # Keep only 1 item
  form.find('[inject] div.item:not(:first-child)').remove()
  # Remove Add Item link
  form.find('a[data-add=item]').parents('[data-type=item]').remove()
  # Loop head properties and update values
  for property, i in head
    form.find("[name='#{property}']").val values[i]
  # Scroll FORM into view
  form[0].scrollIntoView()
  return # End delete event

{%- capture api -%}
## CSV Table

Manage a [CSV table widget]({{ 'docs/widgets/#csv-table' | absolute_url }}){: remote=''}, populate the relative `table[csv-table][data-file]` and store state on `storage`.
{%- endcapture -%}