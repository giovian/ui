#
# Activate Flippers Function
# --------------------------------------
flipper = (flipper) ->
  container = $ flipper
  id = [
      $('body').attr 'page-title'
      $("[class*='flipper']").index container
    ].join '|'
  # Flipper links
  links = container.find('>div:first-child').find('a')
  # Flipper divs
  divs = container.find('>div:not(:first-child)')

  # Assign click event
  links.on 'click', (event) ->
    event.preventDefault()
    link = $ event.target
    index = link.index()
    save = []

    # Hide divs
    divs.addClass 'hidden'

    # Unique
    if container.hasClass 'flipper'
      links.removeClass 'active'
      link.addClass 'active'
      divs.eq(index).removeClass 'hidden'
      save = [index]

    # Multiple
    if container.hasClass 'flippers'
      link.toggleClass 'active'
      # Loop active links
      links.each (i, e) ->
        if $(@).hasClass 'active'
          active = $ @
          # Get attribute and text string
          attribute = active.attr 'data-attribute'
          text = active.text()
          # Show filtered divs
          divs.filter("[#{attribute}*='#{text}']").removeClass 'hidden'
          # Save link index in state array
          save.push i
        return # End active links loop

    # Delete old state, save new state if it isnt [0]
    storage.clear "flippers.#{id}"
    if JSON.stringify(save) isnt JSON.stringify([0])
      storage.assign 'flippers', {"#{id}": save}

    return # End click Event

  # Check saved state (array, .flipper has always 1 element)
  saved = storage.get("flippers.#{id}") || [0]
  # Loop trigger saved links
  saved.map (i) -> links.eq(i).trigger 'click'

  return # Flipper function

# Loop Flippers
$("[class*='flipper']").each -> flipper @

{%- capture api -%}
## Flippers

Show/Hide divs using links and save the state on `storage`.

Class `flipper` is a TAB with one active div visible the time.  
Class `flippers` links have a `data-attribute` and reveals the divs which the selected attribute contains the link text string.

Single `flipper` (tab):
```html
<div class='flipper'>
  <div>
    <a href="#">Alpha</a>
    <a href="#">Beta</a>
    <a href="#">Delta</a>
  </div>
  <div>
    <p>Alpha Beta</p>
  </div>
  <div>
    <p>Gamma Delta</p>
  </div>
  <div>
    <p>Beta Delta</p>
  </div>
</div>
```
Render:
<div class='flipper'>
  <div>
    <a href="#">Alpha</a>
    <a href="#">Beta</a>
    <a href="#">Delta</a>
  </div>
  <div>
    <p>Alpha Beta</p>
  </div>
  <div>
    <p>Gamma Delta</p>
  </div>
  <div>
    <p>Beta Delta</p>
  </div>
</div>
Multiple `flippers` with `categories` and `tags` filter:
```html
<div class='flippers'>
  <div>
    <a href="#" data-attribute="categories">Alpha</a>
    <a href="#" data-attribute="categories">Beta</a>
    <a href="#" data-attribute="tags">Delta</a>
  </div>
  <div categories="Alpha Beta">
    <p>Alpha Beta</p>
  </div>
  <div tags="Gamma Delta">
    <p>Gamma Delta</p>
  </div>
  <div categories="Beta" tags="Delta">
    <p>Beta Delta</p>
  </div>
</div>
```
Render:
<div class='flippers'>
  <div>
    <a href="#" data-attribute="categories">Alpha</a>
    <a href="#" data-attribute="categories">Beta</a>
    <a href="#" data-attribute="tags">Delta</a>
  </div>
  <div categories="Alpha Beta">
    <p>Alpha Beta</p>
  </div>
  <div tags="Gamma Delta">
    <p>Gamma Delta</p>
  </div>
  <div categories="Beta" tags="Delta">
    <p>Beta Delta</p>
  </div>
</div>
{%- endcapture -%}