# Show notification on screen top
notification = (text, cls="blue") ->
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
  $('#notification')
    .removeClass('color-blue color-green color-red color-orange')
    .addClass("color-#{cls}")
    .empty()
    .append(
      $('<div/>', {text: text})
    ).show()
  # Fade out timer
  setTimeout ->
    $('#notification').fadeOut()
  , 3000
  return

# Click to hide
$('#notification').on 'click', -> $(@).hide()