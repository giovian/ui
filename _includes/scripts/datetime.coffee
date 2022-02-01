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

# Convert ISO8601 duration string in milliseconds
duration_ms = (string) ->
  duration = 0
  ms_array = [null, ms.year(), ms.month(), ms.week(), ms.day(), null, ms.hour(), ms.minute(), ms.second]
  array = string.match(/^P(\d+Y)?(\d+M)?(\d+W)?(\d+D)?(T(\d+H)?(\d+M)?(\d+S)?)?$/) || []
  for e, i in ms_array
    if e and array[i] then duration += e * +array[i].slice 0, -1
  return duration

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

datetime = (e) ->

  el = $ e
  date = el.attr 'datetime'
  abs = ms.absolute date

  # Past or Future
  el.removeClass 'past future'
    .addClass if ms.diff(date) > 0 then 'past' else 'future'

  [moment, update] = time_diff date, true

  # Embed or add title attribute
  if el.attr "embed"
    el.attr "title", (i, t) -> t || el.text()
    el.text "#{el.attr('original-text') || el.text()} (#{moment})"
  else if $(e).attr "replace"
    el.attr "title", (i, t) -> t || el.text()
    el.text moment
  else
    el.attr "title", moment

  apply_family()

  # Return a setTimeout function
  setTimeout datetime, update, e

  return # end datetime

# ----

# Delays larger than 2,147,483,647 ms (about 24.8 days) will result in the timeout being executed immediately.
datetime1 = (e) ->

  # Settings
  names = 'second, minute, hour, day, week, month, year'.split(',')
  second = 1000
  minute = second * 60
  hour = minute * 60
  day = hour * 24
  week = day * 7
  month = day * 30.42
  year = week * 52.14
  diff = Date.now() - +new Date(Date.parse $(e).attr "datetime")
  absolute = Math.abs diff

  # Past or Future
  $(e).removeClass 'past future'
    .addClass if diff > 0 then 'past' else 'future'

  # Define functions
  s = (value) -> if value > 1 then 's' else ''
  get_value = (unit) -> Math.round absolute / unit

  switch
    when !get_value second
      moment = "now"
      update = second
    when absolute < minute
      value = get_value second
      moment = "#{value} second#{s value}"
      update = second
      apply_family()
    when absolute < hour - minute
      value = get_value minute
      moment = "#{value} minute#{s value}"
      update = minute
    when absolute < day
      value = get_value hour
      moment = "#{value} hour#{s value}"
      update = minute
    when absolute < week * 2
      value = get_value day
      moment = "#{value} day#{s value}"
      update = day
    when absolute < week * 3.5
      value = get_value week
      moment = "#{value} week#{s value}"
      update = day
    when absolute < year - month
      value = get_value month
      moment = "#{value} month#{s value}"
      update = day
    else
      value = get_value year
      moment = "#{value} year#{s value}"
      update = day

  # `in/ago` function
  out = (moment) ->
    if moment is "now" then "now" else if diff > 0 then "#{moment} ago" else "in #{moment}"

  # Embed or add title attribute
  if $(e).attr "embed"
    $(e).attr "title", (i, t) -> t || $(e).text()
    $(e).text "#{$(e).attr 'original-text'} (#{out moment})"
  else if $(e).attr "replace"
    $(e).attr "title", (i, t) -> t || $(e).text()
    $(e).text out moment
  else
    $(e).attr "title", out moment

  # Return a setTimeout function
  setTimeout datetime, update, e
  
  return # end datetime

$("[datetime]").each -> datetime @

{%- capture api -%}
## Datetime

Update an element with `datetime` attribute showing a countdown or countup.  
Countdown and countup can replace the element text, be appended or appear on hover (tooltip).  
Element will have an updated class `future` or `past`.  
Include a function `time_diff(datetime)`{:.language-coffee} returning the countdown/countup string.
```coffee
span = $ "<span/>",
  datetime: new Date(),
  text: text
datetime(span)
```
There is a liquid widget: [datetime]({{ 'docs/widgets/#datetime' | absolute_url }}).
{%- endcapture -%}