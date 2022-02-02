#
# Fill CSV TABLE function
# --------------------------------------
fill_table = (table, data) ->
  # Get sort
  id = [$('body').attr('page-title'), $('table[csv-table]').index(table)].join '|'
  table.attr 'data-sort', (i, v) -> storage.get("sort.#{id}") || v
  # Get document data
  csv = Base64.decode(data.content).split '\n'
  # Get schema data
  schema_data = get_github_api_data "#{table.attr 'data-file'}.schema.json"
  schema = JSON.parse Base64.decode(schema_data.content)
  # Array of indexes for duration values
  duration_index_array = (index for property, index in Object.keys(schema.items.properties) when schema.items.properties[property].format is 'duration')
  # Array of indexes for date values
  date_index_array = (index for property, index in Object.keys(schema.items.properties) when schema.items.properties[property].format is 'date')
  # Get headers
  headers = csv.shift().split ','
  # Set filter colspan plus #count, plus links
  filter = table.find 'thead.filter'
  filter.find('th').attr 'colspan', headers.length + 2
  # Count header (empty from loading)
  header = table.find 'thead:not(.filter)'
  header.find('#count span').text csv.length
  header.find('#count').css 'min-width', "#{csv.length.toString().length+2}.1em"
  header.find('th:not(#count)').remove()
  # Apply family for sort links
  apply_family()

  # Reset if already populated
  table.find('tbody').empty()
  filter.find('select').empty()

  # Loop headers and populate filter select
  for head, j in headers
    head_cell = $ '<th/>',
      id: head
      text: schema.items.properties[head].title || head
    if schema.items.properties[head].description
      head_cell.attr 'title', schema.items.properties[head].description
    header.find('tr').append head_cell
    filter.find('select').append $ '<option/>', {value: head, text: head}
  # Edit and delete links column
  header.find('tr').append $ '<th/>'

  # Rows loop
  ghost = []
  for row_data, j in csv
    # Create row
    row = $('<tr/>').append "<td>#{j+1}</td>"
    row_values = row_data.split ','
    # Loop row values
    for value, i in row_values
      # Prepare cell
      cell = $ '<td/>',
        headers: headers[i]
        text: value
        value: value
      # Apply datetime to cell
      if date_index_array.length
        if date_index_array[0] is i
          cell.attr 'original-text': value
          datetime cell.attr {'datetime': value, 'embed': true}
      # Check duration value
      if duration_index_array.length and date_index_array.length
        if duration_index_array[0] is i
          if value.startsWith 'P'
            duration = duration_ms value
            # Loop from event to today
            running = +new Date(row_values[date_index_array[0]])
            today = +new Date()
            if running < today
              while running < today
                running += duration
              # Create and store ghost event
              # Array shallow copy
              new_values = row_values.slice 0
              new_values[date_index_array[0]] = new Date(running).toLocaleDateString 'en-CA'
              ghost.push new_values.join ','
      # Append cell
      row.append cell

    # End row loop, Edit remove links
    row.append get_template '#template-service-links-cell'
    # Append row
    if table.attr('data-sort') is 'up'
      table.find('tbody').append row
    else table.find('tbody').prepend row
  # End file loop

  # Loop ghost values
  if ghost.length
    # Sort ghost events, next bottom rows
    ghost_sorted = ghost.sort (a, b) =>
      if a.split(',')[date_index_array[0]] > b.split(',')[date_index_array[0]] then 1 else -1
    for entry in ghost_sorted
      # Prepare row
      row = $('<tr/>').append '<td/>'
      row_values = entry.split ','
      # Loop values and append cells
      for value, i in row_values
        cell = $ '<td/>',
          headers: headers[i]
          text: value
        if i is date_index_array[0]
          cell.attr 'original-text': value
          datetime cell.attr {'datetime': value, 'embed': true}
        row.append cell
      # Add empty service links cell
      row.append '<td/>'
      # Prepend row
      table.find('tbody').prepend row.addClass 'duration'
  # End ghost loop

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
# CSV TABLEs loop
# --------------------------------------
$('table[csv-table][data-file!=""]').each ->
  load_schema_document @, fill_table

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
  tbody.find('tr:not(.duration)').each -> tbody.prepend $ @
  tbody.find('tr.duration').each -> tbody.prepend $ @
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
  row.attr 'disabled', ''
  if !confirm "Delete row #{index}?"
    row.removeAttr 'disabled'
    return
  # delete element `index` in csv array
  document_file = table.attr 'data-file'
  document_url = "#{github_api_url}/contents/_data/#{document_file}.csv"
  stored_data = get_github_api_data document_url
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
    set_github_api_data document_url, stored_data
    # Update table and eventual blocks
    update_csv document_file, stored_data
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
  stored_data = get_github_api_data document_url
  csv = Base64.decode(stored_data.content).split '\n'
  values = csv[index].split ','
  head = csv[0].split ','
  # Apply highlight class
  table.find('tr').removeAttr 'disabled'
  row.attr 'disabled', ''
  # Check Document FORM is present
  form = $ $(document).find("form.document[data-file='#{document_file}']")[0]
  if !Object.keys(form).length
    alert "Include 'widgets/document.html' form in the page"
    row.removeAttr 'disabled'
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

Manage a [CSV table widget]({{ 'docs/widgets/#csv-table' | absolute_url }}), populate the relative `table[csv-table][data-file]` and store state on `storage`.
{%- endcapture -%}