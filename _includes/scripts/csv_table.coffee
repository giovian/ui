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

  # Loop headers and populate filter
  for head in headers
    header.find('tr').append "<th id='#{head}'>#{head}</th>"
    filter.find('select').append $('<option/>', {value: head, text: head})
  # Links column
  header.find('tr').append "<th></th>"

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
    row.append $ '<td><a href="#edit">Edit</a> <a href="#delete">Delete</a></td>'
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
  return # Table populated

#
# Load CSV File
# --------------------------------------
load_csv_table = (element) ->
  table = $ element
  # Get file names
  csv_file = "#{table.attr 'data-file'}.csv"
  schema_file = csv_file.replace '.csv', '.schema.json'

  # Load schema and CSV
  schema_url = "#{github_api_url}/contents/_data/#{schema_file}"
  get_schema = $.get schema_url
  get_schema.done (data) ->
    data = cache data, schema_url
    # Decode schema
    schema = JSON.parse Base64.decode(data.content)
    # Load document file
    document_url = "#{github_api_url}/contents/_data/#{csv_file}"
    get_csv = $.get document_url
    # Fill table
    get_csv.done (data) ->
      data = cache data, document_url
      fill_table data, schema, table
      return # End get_csv
    return # End schema file load

  return # End CSV tables loop

#
# CSV TABLEs loop
# --------------------------------------
$('table[csv-table][data-file!=""]').each -> load_csv_table @

#
# Events
# --------------------------------------

# Hide last borders
hide_last_borders = (table) ->
  table.find('tr').removeClass 'no-border'
  # Remove bottom border from last visible row and thead if no match
  table.find('tr:not(.hidden):last').addClass 'no-border'
  if !table.find('tbody tr:not(.hidden)').length
    table.find('thead:not(.filter) tr').addClass 'no-border'
  return

# Filter event
$(document).on 'input', '.filter select[name=column], .filter input[name=value]', ->
  filter = $(@).parents '.filter'
  table = filter.parents 'table'
  select = filter.find 'select[name=column]'
  selected_index = select.prop 'selectedIndex'
  column = select.val()
  value = filter.find('input[name=value]').val()
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

  if !value
    hide_last_borders table
    return
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

{%- capture api -%}
## CSV Table

Manage a [CSV table widget]({{ 'docs/widgets/#csv-table' | absolute_url }}){: remote=''}, populate the relative `table[csv-table][data-file]` and store state on `storage`.
{%- endcapture -%}