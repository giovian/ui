# Default focus state
focus = document.hasFocus()
if focus then $('html').addClass 'focus'

window.onfocus = ->
  $('html').addClass 'focus'
  focus = true
  return

window.onblur = ->
  $("html").removeClass 'focus'
  focus = false
  return

{%- capture api -%}
## Focus

When the browser page has focus the boolean javascript variabile `focus` will be `true`{:.language-js} and `<html>`{:.language-html} element will have a `.focus`{:.language-css} class.

```coffee
if focus
  # window is focused
else
  # window is blurred
```
{%- endcapture -%}