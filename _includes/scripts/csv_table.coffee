# Sort function
sort_table = (table, col, sort) ->
  multi = if sort is 'down' then -1 else 1
  rows = table.find('tbody tr').sort (a, b) ->
    value_a = $(a).find("td[headers='#{col}']").attr 'value'
    value_b = $(b).find("td[headers='#{col}']").attr 'value'
    if value_a is value_b then return 0
    return if value_a > value_b then multi else -multi
  table.find('tbody tr').remove()
  table.find('tbody').append rows
  return # End sort function

#
# Fill CSV TABLE function
# --------------------------------------
fill_table = (table, data) ->
  # Get sort
  id = [$('body').attr('page-title'), $('.csv-table').index(table)].join '|'
  table.attr 'data-sort', (i, v) -> storage.get("sort.#{id}") || v
  # Get document data
  csv = Base64.decode(data.content).split '\n'
  # Get schema data
  schema_data = cache "#{table.attr 'data-file'}.schema.json"
  schema = JSON.parse Base64.decode(schema_data.content)
  # Array of indexes for duration values
  duration_index_array = (index for property, index in Object.keys(schema.items.properties) when schema.items.properties[property].format is 'duration')
  # Array of indexes for date values
  date_index_array = (index for property, index in Object.keys(schema.items.properties) when schema.items.properties[property].format is 'date')
  # Get headers
  headers = csv.shift().split ','
  # Count header (empty from loading)
  header = table.find 'thead'
  header.find('#counter').text csv.length
  header.find('#counter').css 'min-width', "#{csv.length.toString().length+1}em"
  header.find('th:not(#counter)').remove()

  # Reset if already populated
  table.find('tbody').empty()

  # Loop headers and column filters
  for head, j in headers

    if schema.items.properties[head].format is 'date'
      # Date sortable column head
      head_cell = get_template '#template-sort-links-cell'
      head_cell.find('th').attr 'id', head
      span = head_cell.find 'span'
      span.text schema.items.properties[head].title || head
      if schema.items.properties[head].description
        span.attr 'title', schema.items.properties[head].description
    else
      # fiterable column head
      head_cell = $ '<th/>',
        id: head
      cell_text = schema.items.properties[head].title || head
      # Loop every row and store possible value
      values = []
      for row_data in csv
        values.push row_data.split(',')[j]
      # Create unique options array
      values = Array.from(new Set(values)).sort()
      if values.length is 1
        # Normal cell if no options
        head_cell.text cell_text
      else
        # Options select column head
        select = $ '<select/>'
        # First option without value
        select.append $ '<option/>', {text: cell_text}
        select.append values.map (v) -> $ '<option/>', {text: v, value: v}
        head_cell.append select
      # Add description on mouseover
      if schema.items.properties[head].description
        head_cell.attr 'title', schema.items.properties[head].description

    # Append header cell
    header.find('tr').append head_cell

  # Service links column
  if login.storage()['role'] is 'admin'
    header.find('tr').append $ '<th/>'

  # Loop and append rows
  ghost = []
  origin_date = []
  for row_data, j in csv
    # Create row
    row = $ '<tr/>'
    row.append "<td>#{j+1}</td>"
    row_values = row_data.split ','
    # Loop row values
    for value, i in row_values
      # Prepare cell
      cell = $ '<td/>',
        headers: headers[i]
        text: value
        value: value
      # Apply datetime to cell and past_future class to row
      if date_index_array.length
        if date_index_array[0] is i
          datetime cell.attr {'datetime': value, 'embed': true}
          row.addClass ms.temporize(value)
      # Check duration value
      if duration_index_array.length and date_index_array.length
        if duration_index_array[0] is i
          if value.startsWith 'P'
            duration = duration_ms value
            # Loop from event to today
            running = +new Date(row_values[date_index_array[0]])
            today = +new Date().setHours 0,0,0,0
            if running < today
              while running < today
                running += duration
              # Create and store ghost event
              # Array shallow copy
              new_values = row_values.slice 0
              origin_date.push row_values[date_index_array[0]]
              new_values[date_index_array[0]] = date_iso running
              ghost.push new_values.join ','
      # Append cell
      row.append cell
    # End row loop

    # Add service links
    if login.storage()['role'] is 'admin'
      row.append get_template '#template-service-links-cell'
    
    # Append row
    table.find('tbody').append row
  # End file loop

  # Loop ghost values and prepend rows
  if ghost.length
    # Sort ghost events, next bottom rows
    ghost_sorted = ghost.sort (a, b) =>
      if a.split(',')[date_index_array[0]] > b.split(',')[date_index_array[0]] then 1 else -1
    for entry, j in ghost_sorted
      # Prepare row
      row = $('<tr/>', {class: 'duration'}).append '<td/>'
      row_values = entry.split ','
      # Loop values and append cells
      for value, i in row_values
        cell = $ '<td/>',
          headers: headers[i]
          text: value
          value: value
        if i is date_index_array[0]
          datetime cell.attr {'datetime': value, 'embed': true, 'title': "Originally #{origin_date[j]}"}
          row.addClass ms.temporize(value)
        row.append cell
      # Add empty service links cell
      if login.storage()['role'] is 'admin' then row.append '<td/>'
      # Prepend row
      table.find('tbody').prepend row
  # End ghost loop

  # Check filter saved state for every column
  table.find('th select').each ->
    select = $ @
    column = select.parents('th').attr 'id'
    id = [
      $('body').attr('page-title')
      $('.csv-table').index select.parents('table')
      column
    ].join '|'
    if storage.get("filters.#{id}") isnt undefined
      [selected_index, value] = storage.get("filters.#{id}").split '|'
      select.prop 'selectedIndex', selected_index
      select.trigger 'input'
    return

  # Initial sort table
  if date_index_array.length
    sort_table table, headers[date_index_array[0]], table.attr 'data-sort'

  return # Table populated

#
# Events
# --------------------------------------

# Column Filter event
$('.csv-table[data-file]').on 'input', 'select', ->
  select = $ @
  value = select.val()
  table = select.parents 'table'
  column = select.parents('th').attr 'id'
  selected_index = select.prop 'selectedIndex'
  # Save state in storage
  id = [
    $('body').attr('page-title')
    $('.csv-table').index table
    column
  ].join '|'
  if selected_index isnt 0
    storage.assign 'filters', {"#{id}": "#{selected_index}|#{value}"}
  else storage.clear "filters.#{id}"
  # Reset from last filter
  table.find('tbody tr').removeClass 'hidden'
  table.find('#counter').text table.find('tbody tr').length

  if selected_index is 0 then return
  found = 0
  # Hide rows without a match in cells
  table.find("td[headers='#{column}']").each ->
    if $(@).text() isnt value
      $(@).parents('tr').addClass 'hidden'
    else found++
    return # End cells loop

  # Update found counter
  table.find('#counter').text found
  return # End column filter event

# Sort links events
$('.csv-table[data-file]').on 'click', 'a[href="#up"], a[href="#down"]', ->
  link = $ @
  href = link.attr 'href'
  table = link.parents 'table'
  col = link.parents('th').attr 'id'
  id = [$('body').attr('page-title'), $('.csv-table').index(table)].join '|'
  # Save sort state
  if href is '#up'
    table.attr 'data-sort', sort = 'down'
    # Save sort in storage
    storage.assign 'sort', {"#{id}": 'down'}
  else
    table.attr 'data-sort', sort = 'up'
    storage.clear "sort.#{id}"
  # Update sort links visibility
  sort_table table, col, sort
  return # End sort links

# Delete event
$(document).on 'click', ".csv-table a[href='#remove-entry']", ->
  link = $ @
  row = link.parents 'tr'
  table = row.parents '.csv-table'
  index = +row.children('td:first-child').text()
  row.attr 'disabled', ''
  if !confirm "Delete row #{index}?"
    row.removeAttr 'disabled'
    return
  # delete element `index` in csv array
  document_file = table.attr 'data-file'
  document_url = "#{github_api_url}/contents/_data/#{document_file}.csv"
  stored_data = cache document_url
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
    cache document_url, stored_data
    # Update table and eventual blocks
    update_csv document_file, stored_data
    return # End document update
  put.always -> table.removeAttr 'disabled'

  return # End delete event

# Edit event
$(document).on 'click', ".csv-table a[href='#edit-entry']", ->
  link = $ @
  row = link.parents 'tr'
  index = +row.children('td:first-child').text()
  # Retrieve data
  table = row.parents '.csv-table'
  document_file = table.attr 'data-file'
  document_url = "#{github_api_url}/contents/_data/#{document_file}.csv"
  stored_data = cache document_url
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

Manage a [CSV table widget]({{ 'docs/widgets/#csv-table' | absolute_url }}), populate the relative `.csv-table[data-file]` and store state on `storage`.
{%- endcapture -%}