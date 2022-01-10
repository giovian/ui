#
# Fill CSV TABLE function
# --------------------------------------
fill_table = (data, schema, table) ->

  # Get filter
  filter = get_template '#template-filter'
  # Loop CSV data
  csv = Base64.decode(data.content).split '\n'
  headers = csv.shift().split ','
  # Count header (empty from loading)
  table.find('thead').empty().append $('<tr/>').append $("<th id='count'><span>#{csv.length}</span> </th>").append $ '<a/>', {text: '▲', href: '#up', class: 'prevent-default'}
  # Set width style
  table.find('#count').css 'width', "#{csv.length.toString().length+1}em"
  # Loop headers and populate filter
  for head in headers
    table.find('thead tr').append "<th id='#{head}'>#{head}</th>"
    filter.find('select').append $('<option/>', {value: head, text: head})
  # Append filter if not already present
  if !table.prev('.filter').length then table.before filter

  # Reset if already populated
  table.find('tbody').empty()
  # Rows loop
  for row_data, j in csv
    # Create row
    row = $('<tr/>', {'data-row': j+1}).append "<td>#{j+1}</td>"
    # Loop row values
    widths = []
    for value, i in row_data.split ','
      value_properties = schema.items.properties[headers[i]]
      content = value
      # Check value type
      if value_properties.format is 'date' and value
        date = new Date(value).toLocaleDateString("{{ site.language | default: 'en-US' }}",{weekday: 'short', day: '2-digit', month: 'short', year: 'numeric'})
        content = $ '<span/>', {text: value, datetime: value}
        datetime content
      # Append cell
      row.append $('<td/>', {
          'data-value-type': value_properties.type
          'headers': headers[i]
        }).append content

    # End row loop, append
    table.find('tbody').append row

  # End file loop
  return # Table populated

#
# Load CSV File
# --------------------------------------
load_csv_table = (element) ->
  table = $ element
  table.find('thead').append '<tr class="no-border"><th>Loading</th></tr>'

  # Get file names
  csv_file = "#{table.attr 'data-file'}.csv"
  schema_file = csv_file.replace '.csv', '.schema.json'

  # Load schema and CSV
  get_schema = $.get "#{github_api_url}/contents/_data/#{schema_file}"
  get_schema.done (data, status) ->
    # Decode schema
    schema = JSON.parse Base64.decode(data.content)
    # Load document file
    get_csv = $.get "#{github_api_url}/contents/_data/#{csv_file}"
    # Fill table
    get_csv.done (data, status) -> fill_table data, schema, table
    return # End schema file load

  return # End CSV tables loop

#
# CSV TABLEs loop
# --------------------------------------
$('table.csv[data-file!=""]').each -> load_csv_table @

#
# Events
# --------------------------------------

# Hide last borders
hide_last_borders = (table) ->
  table.find('tr').removeClass 'no-border'
  # Remove bottom border from last visible row and thead if no match
  table.find('tr:not(.hidden):last').addClass 'no-border'
  if !table.find('tbody tr:not(.hidden)').length
    table.find('thead tr').addClass 'no-border'
  return

# Filter event
$(document).on 'input', 'select[name=column], input[name=value]', ->
  filter = $(@).parents 'div.filter'
  column = filter.find('select[name=column]').val()
  value = filter.find('input[name=value]').val()
  table = filter.next 'table'
  # Reset from last filter
  table.find('tr').removeClass 'hidden'
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
$(document).on 'click', '#count a', ->
  link = $ @
  table = link.parents 'table'
  tbody = table.find 'tbody'
  if link.attr('href') is '#up'
    link.attr 'href', '#down'
    link.text '▼'
    tbody.find('tr').each -> tbody.prepend $ @
  else
    link.attr 'href', '#up'
    link.text '▲'
    tbody.find('tr').each -> tbody.prepend $ @
  hide_last_borders table
  return # End sort event

{%- capture api -%}
## CSV

Manage a [CSV table widget]({{ 'docs/widgets/#csv-table' | absolute_url }}){: remote=''}, populate the relative `table.csv[data-file]`.

{%- endcapture -%}