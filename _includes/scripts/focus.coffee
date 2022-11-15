# Default focus state
# similar to html:not(.focus)
focus = false

window.onfocus = ->
  $('html').addClass "focus"
  focus = true
  return

window.onblur = ->
  $("html").removeClass "focus"
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