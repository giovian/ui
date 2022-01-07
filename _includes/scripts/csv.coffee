fill_table = (data, schema, table) ->

  # Get filter
  filter = get_template '#template-filter'
  # Loop CSV data
  csv = Base64.decode(data.content).split '\n'
  headers = csv.shift().split ','
  # Headers
  table.find('thead').empty().append $('<tr/>').append $('<th/>', {text: csv.length})
  for head in headers
    table.find('thead tr').append "<th>#{head}</th>"
    filter.find('select').append $('<option/>', {value: head, text: head})
  # Append filter
  table.before filter

  # Rows
  for row_data, j in csv
    # Create row
    row = $('<tr/>', {'data-row': j+1}).append "<td>#{j+1}</td>"
    # Loop row values
    for value, i in row_data.split ','
      value_properties = schema.items.properties[headers[i]]
      content = value
      # Check value type
      if value_properties.format is 'date' and value
        date = new Date(value).toLocaleDateString("{{ site.language | default: 'en-US' }}",{weekday: 'short', day: '2-digit', month: 'short', year: 'numeric'})
        content = $ '<span/>', {text: date, datetime: value}
        datetime content
      # Append cell
      row.append $('<td/>', {
          'data-value-type': value_properties.type
          'data-column': headers[i]
        }).append content

    # End row loop, append
    table.find('tbody').append row

  # End file loop
  return # Table populated

$('table.csv[data-file!=""]').each ->
  table = $ @
  table.find('thead').append '<tr class="no-border"><th>Loading</th></tr>'

  # Get files
  csv_file = "#{table.attr 'data-file'}.csv"
  schema_file = csv_file.replace '.csv', '.schema.json'

  # Load schema and CSV
  get_schema = $.get "#{github_api_url}/contents/_data/#{schema_file}"
  get_schema.done (data, status) ->
    schema = JSON.parse Base64.decode(data.content)
    get_csv = $.get "#{github_api_url}/contents/_data/#{csv_file}"
    get_csv.done (data, status) -> fill_table data, schema, table  

  return # End CSV tables loop

# Filter event
$(document).on 'input', 'select[name=column], input[name=value]', ->
  filter = $(@).parents 'div.filter'
  column = filter.find('select[name=column]').val()
  value = filter.find('input[name=value]').val()
  table = filter.next 'table'
  # Reset from last filter
  table.find('tr').removeClass 'hidden no-border'
  table.find('thead:first th:first').text table.find('tbody tr').length
  if !value then return
  found = 0
  # Hide rows without a match in cells
  table.find("td[data-column*='#{column}']").each ->
    if !$(@).text().includes value
      $(@).parents('tr').addClass 'hidden'
    else found++
    return # End cells loop
  # Remove bottom border from last visible row and thead if no match
  table.find('tr:not(.hidden):last').addClass 'no-border'
  if !found then table.find('thead tr').addClass 'no-border'
  # Update found counter
  table.find('thead:first th:first').text found
  return # End filter event