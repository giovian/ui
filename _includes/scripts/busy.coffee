busy = (element, status) ->
  if status then $('html').addClass "loading" else $('html').removeClass "loading"
  switch element.prop("tagName")
    when "A" then element.prop "disabled", status
    when "FORM" then element.find(":input").prop "disabled", status
    else console.log element.prop("tagName"), "not recognized"
  return