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
  if absolute < second
    moment = 'now'
    update = second / 2
  else if absolute < (second * 15)
    value = ~~(absolute / second)
    moment = "#{value} second#{s value}"
    update = second
  else if absolute < (second * 30)
    value = ~~(absolute / second)
    moment = "#{value} second#{s value}"
    update = second * 5
  else if absolute < minute
    value = ~~(absolute / second)
    moment = "#{value} second#{s value}"
    update = if (value % 10) is 0 then second * 10 else (value % 10) * 1000
  else if absolute < hour
    value = ~~(absolute / minute)
    moment = "#{value} minute#{s value}"
    update = minute
  else if absolute < day
    value = ~~(absolute / hour)
    moment = "#{value} hour#{s value}"
    update = hour
  else if absolute < week
    value = ~~(absolute / day)
    moment = "#{value} day#{s value}"
    update = day
  else if absolute < 4 * week
    value = ~~(absolute / week)
    moment = "#{value} week#{s value}"
    update = week
  else if absolute <= year
    value = ~~(absolute / month)
    moment = "#{value} month#{s value}"
    update = month
  else
    moment = "#{~~(absolute / year)} year#{s value}"
    update = year
  # Past or Future
  out = if moment isnt 'now'
    if diff > 0 then "#{moment} ago" else "in #{moment}"
  else moment
  # Embed or add title attribute
  if $(e).data "embed"
    $(e).text "#{$(e).attr 'original-text'} (#{out})"
  else if $(e).data "replace"
    text = $(e).text()
    $(e).text out
    $(e).attr "title", (i, t) -> if not t then text
  else
    $(e).attr "title", (i, t) -> if not t then out
  $(e).removeClass('past future').addClass () -> if diff > 0 then 'past' else 'future'
  # Return a setTimeout function
  setTimeout ->
    dateTime e
  , update

$("[datetime]").each -> dateTime @