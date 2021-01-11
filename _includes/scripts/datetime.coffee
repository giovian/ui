dateTime = (e) ->
  second = 1000
  minute = second * 60
  hour = minute * 60
  day = hour * 24
  week = day * 7
  month = day * 30.42
  year = week * 52.14
  diff = new Date().getTime() - (new Date(Date.parse $(e).attr "datetime").getTime())
  absolute = Math.abs diff
  # 's' function
  s = (value) -> if value >= 2 then 's' else ''
  # Check range
  if absolute < (second * 11)
    moment = "now"
    update = second * 5
  else if absolute < minute
    moment = "less than a minute"
    update = second * 10
  else if absolute < hour
    value = Math.round(absolute / minute)
    moment = "#{value} minute#{s value}"
    update = minute
  else if absolute < day
    value = Math.round(absolute / hour)
    moment = "#{value} hour#{s value}"
    update = hour
  else if absolute < (week * 2)
    value = Math.round(absolute / day)
    moment = "#{value} day#{s value}"
    update = day
  else if absolute < 3.5 * week
    value = Math.round(absolute / week)
    moment = "#{value} week#{s value}"
    update = week
  else if absolute < year
    value = Math.round(absolute / month)
    moment = "#{value} month#{s value}"
    update = month
  else
    value = Math.round(absolute / year)
    moment = "#{value} year#{s value}"
    update = year
  # Past or Future
  $(e).removeClass('past future')
  if diff > 0
    formula = "#{moment} ago"
    $(e).addClass 'past'
  else
    formula = "in #{moment}"
    $(e).addClass 'future'
  out = if moment isnt 'now' then formula else moment
  # Embed or add title attribute
  if $(e).data "embed"
    $(e).text "#{$(e).attr 'original-text'} (#{out})"
  else if $(e).data "replace"
    text = $(e).text()
    $(e).text out
    $(e).attr "title", (i, t) -> if not t then text
  else
    $(e).attr "title", out
  # Return a setTimeout function
  setTimeout ->
    dateTime e
  , update

$("[datetime]").each -> dateTime @