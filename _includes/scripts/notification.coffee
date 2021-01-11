# Show notification on screen top
notification_reset = ->
  $('html').removeClass 'loading'
  $('#notification').fadeOut(400, ->
    $('#notification').empty()
      .removeClass 'cliccable color-blue color-green color-red color-orange'
    return
  )
  return

notification = (text, cls, end) ->
  # Store in storage
  # logs_array = storage.get 'storage.logs'
  # logs_array.unshift {time: new Date(), text: text, cls: cls}
  # storage.set 'storage.logs', logs_array.slice(0, 20)
  # Append in logs details
  # $('.logs').prepend return_log {
  #   time: new Date()
  #   text: text
  #   cls: cls
  # }
  # Show notification
  $('html').addClass 'loading'
  $('#notification')
    .removeClass 'cliccable color-blue color-green color-red color-orange'
    .addClass () -> if cls then "color-#{cls}"
    .addClass () -> if end then 'cliccable'
    .append $ '<div/>', {text: text}
    .show()
  # Fade out timer
  if end then setTimeout notification_reset, 3000
    # $('html').removeClass 'loading'
    # setTimeout ->
    #   $('#notification').fadeOut(400, -> return notification_reset())
    # , 3000
  return

# Click to hide
$('#notification').on 'click', -> if $(@).hasClass('cliccable') then notification_reset()