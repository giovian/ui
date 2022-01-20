#
# Fill CSV BLOCKS function
# --------------------------------------
fill_blocks = (data, schema, div) ->

  # Loop CSV data
  csv = Base64.decode(data.content).split '\n'
  headers = csv.shift().split ','
  blocks = div.attr('data-blocks') || 14
  width = Math.floor div.width() / blocks
  today = +new Date()
  running = today - ((blocks-1) * ms.day())
  for days in [1..blocks]
    day = new Date(running).toLocaleDateString 'en-CA'
    block = $ '<div/>', {title: day}
    if csv.some((e) -> e.includes day)
      block.addClass 'present'
    running += ms.day()
    div.append block.css({width: width, height: width})
  return # End Blocks fill

#
# Load CSV File
# --------------------------------------
load_csv_blocks = (element) ->
  div = $ element
  # Get file names
  csv_file = "#{div.attr 'data-file'}.csv"
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
      fill_blocks data, schema, div
      return # End get document
    return # End schema file load
  
  return # End CSV tables loop

#
# CSV Blocks loop
# --------------------------------------
$('div[csv-blocks][data-file!=""]').each -> load_csv_blocks @

{%- capture api -%}
## CSV Blocks

Manage a [CSV blocks widget]({{ 'docs/widgets/#csv-blocks' | absolute_url }}){: remote=''}, populate the relative `div[csv-blocks][data-file]`.
{%- endcapture -%}