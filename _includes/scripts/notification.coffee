notification = (code, cls, persist = false) ->
  # Create notification SPAN
  color_class = "#{if cls then "color-#{cls}" else 'bg-secondary'}"
  div = $ "<div class='#{color_class}'><span>#{code}</span></div>"
  $('.notification').each ->
    container = $(@)
    container.append div
    # Log notification in console as well
    console.log $("<b>#{code}</b>").text(), new Date().toLocaleTimeString('it-IT')
    # Timer to fade and expire
    if !persist then div.delay(3000).slideUp 'slow', -> div.remove()

    return # Containers loop

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