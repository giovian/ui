sort = (container) ->
  # Check sort direction in container data-sort attribute
  multi = if container.data('sort') is 'desc' then -1 else 1
  # Create sorted array of elements
  sorted = container.find('[sort]').sort (a, b) ->
    value_a = $(a).attr 'sort'
    value_b = $(b).attr 'sort'
    if value_a is value_b then return 0
    return if value_a > value_b then multi else -multi
  # remove old and append new elements
  container.find('[sort]').remove()
  container.append sorted
  return

$('[sort]').parent().each () -> sort $ @

{%- capture api -%}
## Sort

Elements with `sort` attribute will be sorted in their parent element by their values.
Default sort direction is `asc` (small to big), parent element can have attribute `data-sort` being `desc`

```html
<div data-sort='desc'>
  <div sort="4">4</div>
  <div sort="1">1</div>
  <div sort="3">3</div>
</div>
```
Rendered HTML
<div data-sort='desc'>
  <div sort="4">4</div>
  <div sort="1">1</div>
  <div sort="3">3</div>
</div>
{%- endcapture -%}