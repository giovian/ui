focus = true

window.onfocus = ->
  $('html').toggleClass "focus"
  focus = true
  return

window.onblur = ->
  $("html").toggleClass "focus"
  focus = false
  return

{%- capture api -%}
## Focus

Boolean variabile `focus` indicate browser page focus status.

```coffee
if focus
  # window is focused
else
  # window is blurred
```
{%- endcapture -%}