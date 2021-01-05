dateTime = (e) ->
  minute = 1000 * 60
  hour = minute * 60
  day = hour * 24
  week = day * 7
  month = day * 30.42
  year = week * 52.14
  decimals = $(e).data("decimals") || 0
  diff = new Date().getTime() - (new Date(Date.parse $(e).attr "datetime").getTime()) #+ (12 * hour)) Consider noon instead of midnight
  absolute = Math.abs diff
  # 's' function
  s = (value) -> if value >= 2 then 's' else ''
  # Check range
  if absolute < hour
    value = (absolute / minute).toFixed decimals
    moment = "#{value} minute#{s value}"
  else if absolute < day
    value = (absolute / hour).toFixed decimals
    moment = "#{value} hour#{s value}"
  else if absolute < week
    value = (absolute / day).toFixed decimals
    moment = "#{value} day#{s value}"
  else if absolute < 4 * week
    value = (absolute / week).toFixed decimals
    moment = "#{value} week#{s value}"
  else if absolute < year
    value = (absolute / month).toFixed decimals
    moment = "#{value} month#{s value}"
  else moment = "#{(absolute / year).toFixed decimals} year#{s value}"
  # Past or Future
  out = if diff > 0 then "#{moment} ago" else "in #{moment}"
  # Embed or add title attribute
  if $(e).data "embed"
    $(e).text "#{$(e).attr("datetime").slice 0, 10} (#{out})"
  else if $(e).data "replace"
    $(e).text out
    $(e).attr "title", new Date(Date.parse $(e).attr "datetime")
  else
    $(e).attr "title", out
  # Set every minute
  # Return a setTimeout function
  setTimeout ->
    dateTime e
  , 60 * 1000

$("[datetime]").each -> dateTime @