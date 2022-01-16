notification = (code, cls, persist = false) ->
  # Create notification SPAN
  color_class = cls || 'bg-secondary'
  div = $ "<div class='#{color_class}'><div class='spacer'></div><span>#{code}</span></div>"
  $('.notification').each ->
    container = $(@)
    if persist then container.empty()
    container.append div
    # Log notification in console as well
    console.log $("<b>#{code}</b>").text(), new Date().toLocaleTimeString("{{ site.language | default: 'en-US' }}")
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
- `color`: added as class, default to `.bg-secondary`{:.language-sass}
- `persist`: boolean, if `true` the notification will not fade out
{%- endcapture -%}