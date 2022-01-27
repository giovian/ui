#
# Fill CSV BLOCKS function
# --------------------------------------
fill_calendar = (div, data) ->
  # Create data array without headers
  csv = Base64.decode(data.content).split('\n').slice 1
  # Prepare DIV
  div.empty()
  months = +div.attr 'data-months'
  width_months = Math.floor div.width() / 2
  width_days = Math.floor width_months / 7
  height_months = width_days * 5
  # Loop days
  running = +new Date() - ((months * 30.4 / 2) * ms.day())
  for d in [1..(months*30)]
    # Get day and month
    day = new Date(running)
    day_formatted = day.toLocaleDateString 'en-CA'
    day_number = +day.getDate()
    day_week = day.getDay()
    month = day.getMonth()
    # Check month DIV
    if !div.has("[month='#{month}']").length
      first_day = "#{day.getFullYear()}-#{day.getMonth()+1}-01"
      first_day_week = new Date(first_day).getDay()
      month_div = $('<div/>', {month: month}).css
        'grid-template-rows': "#{width_days}px"
      if day_number isnt 1
        month_div.css 'align-content', 'end'
      div.append month_div
    # Create day DIV
    text = day.toLocaleDateString "{{ site.language | default: 'en-US' }}",
      weekday: 'narrow'
      day: 'numeric'
    day_div = $ '<div/>',
      day: day.getDate()
      title: day_formatted
      text: text
    # Style day DIV
    day_div.css
      width: "#{width_days}px"
      height: "#{width_days}px"
      'grid-column-start': day.getDay() + 1
      'grid-row-start': Math.ceil (day_number+first_day_week)/7
    index = csv.findIndex (e) -> e.includes day_formatted
    # Check if day is present in document
    if index isnt -1
      day_div.attr 'title', csv[index].replace /,/g, ', '
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
## CSV Blocks

Manage a [CSV blocks widget]({{ 'docs/widgets/#csv-blocks' | absolute_url }}){: remote=''}, populate the relative `div[csv-blocks][data-file]`.
{%- endcapture -%}