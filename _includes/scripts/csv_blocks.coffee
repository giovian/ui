#
# Fill CSV BLOCKS function
# --------------------------------------
fill_blocks = (div, data) ->
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
  # Prepare DIV
  div.empty()
  blocks = +div.attr 'data-blocks'
  width = Math.floor div.width() / blocks
  # Compute blocks range
  flow = if div.attr('data-flow') is 'future' then 1 else -1
  range = (blocks - 1) * ms.day()
  running = +new Date() + flow * range
  end = +new Date()
  # Loop all csv for durations
  ghost = []
  for row in csv
    values = row.split ','
    # Check every row for duration
    # Only the first duration value will be used
    if duration_index_array.length and date_index_array.length
      if values[duration_index_array[0]].startsWith 'P'
        duration = duration_ms values[duration_index_array[0]]
        # Get event date and start loop from first repetition
        # Only the first date value will be used
        calendar_date = +new Date(values[date_index_array[0]])
        calendar_date += duration
        while calendar_date < Math.max end, running
          values[date_index_array[0]] = new Date(calendar_date).toLocaleDateString 'en-CA'
          ghost.push values.join ','
          calendar_date += duration
  # End csv duration loop
  # Loop days inside blocks range
  while flow * running >= flow * end
    day = new Date(running)
    day_formatted = day.toLocaleDateString 'en-CA'
    text = day.toLocaleDateString "{{ site.language | default: 'en-US' }}",
      weekday: 'narrow'
      day: 'numeric'
    block = $ '<div/>',
      title: day_formatted
      text: text
    # Check if day is present as repetition
    index = ghost.findIndex (e) -> e.includes day_formatted
    if index isnt -1
      block.attr 'title', ghost[index].split(',').map((e, i) ->
        if e then "#{schema.items.properties[headers[i]].title || headers[i]}: #{e}").join '\n'
      block.addClass 'present'
    # Check if ghost is present in document
    index = csv.findIndex (e) -> e.includes day_formatted
    if index isnt -1
      block.attr 'title', csv[index].split(',').map((e, i) ->
        if e then "#{schema.items.properties[headers[i]].title || headers[i]}: #{e}").join '\n'
      block.addClass 'present'
    # Check if it is today
    if day_formatted is new Date().toLocaleDateString 'en-CA'
      block.addClass 'today'
    # Append blocks DIV
    div.append block.css
      height: width
    running -= flow * ms.day()
  return # End Blocks fill

#
# CSV Blocks loop
# --------------------------------------
$('.csv-blocks[data-file]').each ->
  load_schema_document @, fill_blocks

{%- capture api -%}
## CSV Blocks

Manage a [CSV blocks widget]({{ 'docs/widgets/#csv-blocks' | absolute_url }}), populate the relative `.csv-blocks[data-file]`.
{%- endcapture -%}