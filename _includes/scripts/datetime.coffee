ms =
  names: 'second, minute, hour, day, week, month, year'.split(',')
  second: 1000
  minute: -> ms.second * 60
  hour: -> ms.minute() * 60
  day: -> ms.hour() * 24
  week: -> ms.day() * 7
  month: -> ms.day() * 30.42
  year: -> ms.week() * 52.14
  diff: (date) -> Date.now() - +new Date(Date.parse date)
  absolute: (date) -> Math.abs ms.diff(date)
  s: (value) -> if value > 1 then 's' else ''
  get_value: (date, unit) -> Math.round ms.absolute(date) / unit
  today: (date) -> if (new Date date).setHours(0,0,0,0) is new Date().setHours(0,0,0,0) then 'today' else past_future date
  past_future: (date) -> if ms.diff(date) > 0 then 'past' else 'future'

# Convert ISO8601 duration string in milliseconds
duration_ms = (string) ->
  duration = 0
  ms_array = [null, ms.year(), ms.month(), ms.week(), ms.day(), null, ms.hour(), ms.minute(), ms.second]
  array = string.match(/^P(\d+Y)?(\d+M)?(\d+W)?(\d+D)?(T(\d+H)?(\d+M)?(\d+S)?)?$/) || []
  for e, i in ms_array
    if e and array[i] then duration += e * +array[i].slice 0, -1
  return duration

# Apply `past/future` class to elements with attribute `check-past-future='date'`
$("[check-past-future]").each -> $(@).addClass ms.past_future $(@).attr 'check-past-future'

# Apply `today` class to elements with attribute `check-today='date'`
$('[check-today]').each -> $(@).addClass ms.today $(@).attr 'check-today'

time_diff = (date, return_update) ->
  abs = ms.absolute date
  switch
    when !ms.get_value date, ms.second
      moment = "now"
      update = ms.second
    when abs < ms.minute()
      value = ms.get_value date, ms.second
      moment = "#{value} second#{ms.s value}"
      update = ms.second
    when abs < ms.hour() - ms.minute()
      value = ms.get_value date, ms.minute()
      moment = "#{value} minute#{ms.s value}"
      update = ms.minute()
    when abs < ms.day()
      value = ms.get_value date, ms.hour()
      moment = "#{value} hour#{ms.s value}"
      update = ms.minute()
    when abs < ms.week() * 2
      value = ms.get_value date, ms.day()
      moment = "#{value} day#{ms.s value}"
      update = ms.day()
    when abs < ms.week() * 3.5
      value = ms.get_value date, ms.week()
      moment = "#{value} week#{ms.s value}"
      update = ms.day()
    when abs < ms.year() - ms.month()
      value = ms.get_value date, ms.month()
      moment = "#{value} month#{ms.s value}"
      update = ms.day()
    else
      value = ms.get_value date, ms.year()
      moment = "#{value} year#{ms.s value}"
      update = ms.day()
  if moment isnt 'now'
    moment = if ms.diff(date) > 0 then "#{moment} ago" else "in #{moment}"
  return if return_update then [moment, update] else moment

# Delays larger than 2,147,483,647 ms (about 24.8 days) will result in the timeout being executed immediately.
datetime = (e) ->

  el = $ e
  date = el.attr 'datetime'
  abs = ms.absolute date

  # Past or Future
  el.removeClass 'past future'
    .addClass ms.past_future(date)

  [moment, update] = time_diff date, true

  # Embed or add title attribute
  if el.attr "embed"
    el.attr "title", (i, t) -> t || el.text()
    el.find('span[relative-time]').remove()
    el.append "\n<span relative-time>#{moment}</span>"
  else if $(e).attr "replace"
    el.attr "title", (i, t) -> t || el.text()
    el.text moment
  else
    el.attr "title", moment

  # Return a setTimeout function
  setTimeout datetime, update, e

  return # end datetime

# Loop page elements
$("[datetime]").each -> datetime @

{%- capture api -%}
## Datetime

Update an element with `datetime` attribute showing a relative time counter.  
Relative time can: replace the element text, be appended to, or appear on hover (tooltip).  
Element will have an updated class `future` or `past`.  
Include a function `time_diff(datetime, return_update)`{:.language-coffee} returning the relative time string and optionally the milliseconds to the next update.  
Class `past` or `future` is applyed to elements with attribute `[check-past-future='date']`{:.language-html}.
The class 'today'is applyed to elements with attribute `[check-today]='date'`{:.language-html} if it is the case.
```coffee
# Element
element = $ "<span/>",
  datetime: new Date(),
  text: text
# Update
datetime(element)
# Get relative time
console.log time_diff(date)
```
There is a liquid widget: [datetime]({{ 'docs/widgets/#datetime' | absolute_url }}).
{%- endcapture -%}