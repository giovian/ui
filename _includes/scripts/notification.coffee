notification = (code, cls, persist = false) ->
  # Create notification SPAN
  span = $('<span/>').append code
  color_class = "#{if cls then "color-#{cls}" else 'bg-secondary'}"
  $('#notification').empty().attr('class','').addClass(color_class).append span
  # Timer to fade and expire
  if persist then return
  span.delay(3000).fadeOut 'slow', ->
    span.remove()
    $('#notification').removeClass color_class
    return # End fadeout delay
  # Log notification in console as well
  console.log $("<b>#{code}</b>").text(), new Date().toLocaleTimeString('it-IT')
  return # end notification
{%- capture api -%}
## Notification

Render a notification on the navigation bar with custom text and color.  
Will fadeout after 3 seconds.

```coffee
notification('text', 'color', persist)
```

**Arguments**

- `text`: text to show
- `color`: added as class with prepended `.color-`{:.language-sass}.  
  Default to `.bg-secondary`{:.language-sass}
- `persist`: boolean, if `true` the notification will not fade out
{%- endcapture -%}