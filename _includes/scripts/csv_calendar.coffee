#
# Fill CSV BLOCKS function
# --------------------------------------
fill_calendar = (div, data) ->
  # Create data array and headers
  csv = Base64.decode(data.content).split '\n'
  headers = csv.shift().split ','
  # Search schema properties with `format: duration`
  schema_file = "#{div.attr 'data-file'}.schema.json"
  schema = JSON.parse Base64.decode get_github_api_data(schema_file).content
  # Array of indexes for duration values
  duration_index_array = (index for property, index in Object.keys(schema.items.properties) when schema.items.properties[property].format is 'duration')
  # Array of indexes for date values
  date_index_array = (index for property, index in Object.keys(schema.items.properties) when schema.items.properties[property].format is 'date')
  # Prepare calendar DIV
  div.empty()
  months = +div.attr 'data-months'
  width_months = Math.floor div.width() / 2
  width_days = Math.floor width_months / 7
  height_months = width_days * 5
  # Compute calendar range
  range = months * 30 * ms.day()
  running = +new Date() - range / 2
  end = +new Date() + range / 2
  # Loop all csv for durations
  ghost = []
  for row in csv
    values = row.split ','
    # Check every row for duration
    # Only the first duration value will be used
    if values[duration_index_array[0]].startsWith 'P'
      duration = duration_ms values[duration_index_array[0]]
      # Get event date and start loop from first repetition
      # Only the first date value will be used
      calendar_date = +new Date(values[date_index_array[0]])
      calendar_date += duration
      while calendar_date < end
        values[date_index_array[0]] = new Date(calendar_date).toLocaleDateString 'en-CA'
        ghost.push values.join ','
        calendar_date += duration
  # End csv duration loop
  # Loop days in interval `data-months`
  while running < end
    # Get day and month
    day = new Date(running)
    day_formatted = day.toLocaleDateString 'en-CA'
    day_number = +day.getDate()
    day_week = day.getDay()
    month = day.getMonth()
    # Check month DIV
    if !div.has("[month='#{month}']").length
      # Check first day of the month
      first_day = "#{day.getFullYear()}-#{day.getMonth()+1}-01"
      first_day_week = new Date(first_day).getDay()
      # Create div
      month_div = $('<div/>', {month: month})
      # Push bottom if end of month
      month_div.css 'align-content', if day_number is 1 then 'start' else 'end'
      div.append month_div
    # Create day DIV
    text = day.toLocaleDateString "{{ site.language | default: 'en-US' }}",
      weekday: 'narrow'
      day: 'numeric'
    day_div = $ '<div/>',
      day: day.getDate()
      title: day_formatted
      text: text
    # Set size and position
    day_div.css
      height: "#{width_days}px"
      'grid-column-start': day.getDay() + 1
      'grid-row-start': Math.ceil (day_number+first_day_week)/7
    # Check if day is present as repetition
    index = ghost.findIndex (e) -> e.includes day_formatted
    if index isnt -1
      day_div.attr 'title', ghost[index].split(',').map((e, i) ->
        if e then "#{schema.items.properties[headers[i]].title || headers[i]}: #{e}").join '\n'
      day_div.addClass 'present'
    # Check if day is present in document
    index = csv.findIndex (e) -> e.includes day_formatted
    if index isnt -1
      day_div.attr 'title', csv[index].split(',').map((e, i) ->
        if e then "#{schema.items.properties[headers[i]].title || headers[i]}: #{e}").join '\n'
      day_div.addClass 'present'
    # Check if it is today
    if day_formatted is new Date().toLocaleDateString 'en-CA'
      day_div.addClass 'today'
    # Append day DIV
    div.find("[month='#{month}']").append day_div
    running += ms.day()
  return # End Blocks fill

#
# CSV Calendar loop
# --------------------------------------
$('div[csv-calendar][data-file!=""]').each ->
  load_schema_document @, fill_calendar

{%- capture api -%}
## CSV Calendar

Manage a [CSV Calendar widget]({{ 'docs/widgets/#csv-calendar' | absolute_url }}), populate the relative `div[csv-calendar][data-file]`.
{%- endcapture -%}