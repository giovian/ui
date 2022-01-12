#
# Reset functions
# --------------------------------------
reset_tabs = (tab, link_index) ->
  container = $(tab)
  id = [$('body').attr('page-title'), $('[tab-container]').index(container)].join '|'
  index = link_index || storage.get("tabs.#{id}") || 0
  # Activate index link
  container.find('a[data-tab]').eq(index).addClass 'active'
  # Hide non-index tabs
  container.find('div[data-tab]').each (i,e) ->
    if i isnt index then $(@).addClass 'hidden'
  return

#
# Initial TABs reset
# --------------------------------------
$('[tab-container]').each -> reset_tabs @

#
# TAB link click event
# --------------------------------------
$(document).on "click", "a[data-tab]", (event) ->
  event.preventDefault()
  link = $(@)

  # Get container
  container = link.parents '[tab-container]'

  # Activate link
  container.find('a[data-tab]').removeClass 'active'
  link.addClass 'active'

  # Show/hide TABs
  container.find('div[data-tab]').each (i,e) ->
    if i isnt link.index() then $(@).addClass 'hidden' else $(@).removeClass 'hidden'

  # Save TAB link click on storage
  id = [$('body').attr('page-title'), $('[tab-container]').index(container)].join '|'
  if link.index() > 0
    storage.assign 'tabs', {"#{id}": link.index()}
  else storage.clear "tabs.#{id}"

  return # End link click event

{%- capture api -%}
## TABs

Manage Show/Hide TABs with links and save the state on `storage`.

```html
<div tab-container>
  <div tab-links>
    <a href="#" data-tab>First tab</a>
    <a href="#" data-tab>Second tab</a>
    <a href="#" data-tab>Third tab</a>
  </div>
  <div data-tab>
    <p>First content</p>
  </div>
  <div data-tab>
    <p>Second content</p>
  </div>
  <div data-tab>
    <p>Third content</p>
  </div>
</div>
```
Render:
<div tab-container>
  <div tab-links>
    <a href="#" data-tab>First tab</a>
    <a href="#" data-tab>Second tab</a>
    <a href="#" data-tab>Third tab</a>
  </div>
  <div data-tab>
    <p>First content</p>
  </div>
  <div data-tab>
    <p>Second content</p>
  </div>
  <div data-tab>
    <p>Third content</p>
  </div>
</div>
{%- endcapture -%}