$('details').each ->

  # Prepare
  detail = $ @
  summary = detail.find 'summary'
  id = "#{$('body').attr 'page-title'}|#{$.trim summary.text()}"

  # Initial check
  if storage.get('details')?[id] isnt undefined
    if storage.get('details')[id]
      detail.attr 'open', ''
    else
      detail.removeAttr 'open'

  # Click event
  summary.on 'click', ->
    # false = closing, true = opening
    open = !detail.attr? 'open'
    if storage.get('details')?[id] is undefined
      storage.assign 'details', {"#{id}": open}
    else storage.clear "details.#{id}"
    return

  return # End DETAILS loop

{%- capture api -%}
## Detail

Store the state of the DETAIL elements (open/close) in every page.

```js
details: {
  "forms|Table of contents": false
}
```
<details>
<summary>Example</summary>
Content
</details>
{%- endcapture -%}