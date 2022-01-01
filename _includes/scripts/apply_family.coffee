apply_family = ->

  $('[apply-if-parent]').each ->
    [apply, match] = $(@).attr('apply-if-parent').split '|'
    $(@).removeClass apply
    if $(@).parents(match).length then $(@).addClass apply
    return # end elements loop

  $('[apply-if-children]').each ->
    [apply, match] = $(@).attr('apply-if-children').split '|'
    $(@).removeClass apply
    if $(@).find(match).length then $(@).addClass apply
    return # end elements loop

  return # end apply_family

apply_family()
{%- capture api -%}
## Apply _family_

Element attribute `apply-if-children` in the form `class|children` will apply the `class` to the element if `children` is a descendant.

Element attribute `apply-if-parent` in the form `class|parent` will apply the `class` to the element if `parent` is a parent.

- `class` is a space separated class list
- `children` and `parent` are selectors

The function `apply_family()` is initially called after login check (even if no login interface is present) and when `datetime` events are `now`.

**Examples**

```html
<!-- paragraph will have `hidden` class if has any parent with class `logged` -->
<p apply-if-parent="hidden|.logged">...</p>

<!-- table will have `no-border color-red` classes if has any children with class `past` -->
<table apply-if-children="no-border color-red|.past">...</table>
```
{%- endcapture -%}