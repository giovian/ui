#
# Fill CSV COUNTER function
# --------------------------------------
fill_counter = (div, data) ->
  # Create data array and headers
  csv = Base64.decode(data.content).split '\n'
  headers = csv.shift().split ','
  # Search schema properties with `format: duration`
  schema_file = "#{div.attr 'data-file'}.schema.json"
  schema = JSON.parse Base64.decode get_github_api_data(schema_file).content
  # Array of indexes for date values
  date_index_array = (index for property, index in Object.keys(schema.items.properties) when schema.items.properties[property].format is 'date')
  # Prepare DIV
  div.empty()
  days = +div.attr 'data-days'
  running = +Date.parse(div.attr('data-start') || new Date().toLocaleDateString 'en-CA')
  end = new Date running
  end = end.setDate(end.getDate()-days)
  # Loop days inside blocks range
  counted = 0
  while running >= end
    day = new Date running
    day_formatted = day.toLocaleDateString 'en-CA'
    # Check if day_formatted is present in document
    index = csv.findIndex (e) -> e.includes day_formatted
    if index isnt -1 then counted += 1
    running -= ms.day()
  # Append Counted Bar DIV
  percent = Math.floor 100 * counted/days
  div.append $ '<div/>',
    title: "#{counted} of #{days}: #{percent}%"
    text: counted
    width: "#{percent}%"
  # Append Empty Bar DIV
  div.append $ '<div/>',
    title: "#{days-counted} of #{days}: #{100-percent}%"
    text: days-counted
    class: 'off'
    width: "#{100-percent}%"
  return # End Counter fill

#
# CSV Blocks loop
# --------------------------------------
$('.bar[data-file]').each ->
  load_schema_document @, fill_counter

{%- capture api -%}
## CSV Counter

Manage a [CSV counter widget]({{ 'docs/widgets/#csv-counter' | absolute_url }}), populate the relative `.bar[data-file]`.
{%- endcapture -%}