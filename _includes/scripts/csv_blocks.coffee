#
# Fill CSV BLOCKS function
# --------------------------------------
fill_blocks = (div, data) ->
  # Create data array without headers
  csv = Base64.decode(data.content).split('\n').slice 1
  # Prepare DIV
  div.empty()
  blocks = +div.attr 'data-blocks'
  width = Math.floor div.width() / blocks
  # Loop days
  multi = if div.attr('data-flow') is 'future' then 1 else -1
  running = +new Date() + multi * ((blocks-1) * ms.day())
  for days in [1..blocks]
    day = new Date(running).toLocaleDateString 'en-CA'
    text = new Date(running).toLocaleDateString "{{ site.language | default: 'en-US' }}",
      weekday: 'narrow'
      day: 'numeric'
    block = $ '<div/>',
      title: day
      text: text
    index = csv.findIndex (e) -> e.includes day
    if index isnt -1
      block.attr 'title', csv[index].replace /,/g, ', '
      block.addClass 'present'
    if day is new Date().toLocaleDateString 'en-CA'
      block.addClass 'today'
    running += (multi*-1) * ms.day()
    div.append block.css
      width: width
      height: width
  return # End Blocks fill

#
# CSV Blocks loop
# --------------------------------------
$('div[csv-blocks][data-file!=""]').each ->
  load_schema_document @, fill_blocks

{%- capture api -%}
## CSV Blocks

Manage a [CSV blocks widget]({{ 'docs/widgets/#csv-blocks' | absolute_url }}){: remote=''}, populate the relative `div[csv-blocks][data-file]`.
{%- endcapture -%}