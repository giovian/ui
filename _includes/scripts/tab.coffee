#
# Reset functions
# --------------------------------------
reset_tabs = (tab) ->
  container = $(tab)
  # Activate first link
  container.find('a[data-tab]:first-of-type').addClass 'active'
  # Show first tab
  container.find('div[data-tab]:not(:first)').addClass 'hidden'
  return

#
# Initial TABs reset
# --------------------------------------
$('[tab-container]').each -> reset_tabs @

#
# TAB link click event
# --------------------------------------
$(document).on "click", "a[data-tab]", ->

  # Get container
  container = $(@).parents '[tab-container]'

  # Activate link
  container.find('a[data-tab]').removeClass 'active'
  $(@).addClass 'active'

  # Show/hide TABs
  container.find('div[data-tab]').addClass 'hidden'
  container.find('div[data-tab]').eq($(@).index()).removeClass 'hidden'

  return # End link click event

{%- capture api -%}
## TABs

Manage Show/Hide TABs with links

```html
<div tab-container>
  <div tab-links>
    <a href="#" data-tab>1</a>
    <a href="#" data-tab>2</a>
  </div>
  <div data-tab>
    <h1>Uno</h1>
  </div>
  <div data-tab>
    <h1>Due</h1>
  </div>
</div>
```
{%- endcapture -%}