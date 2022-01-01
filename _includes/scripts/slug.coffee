slug = (string) -> 
  return string.toString().toLowerCase().trim()
  .replace /[^\w\s-]/g, ''
  .replace /[\s_-]+/g, '_'
  .replace /^-+|-+$/g, ''

unslug = (string) ->
  out = string.replace /[_-]/g, ' '
  return out.charAt(0).toUpperCase() + out.slice 1

{%- capture api -%}
## Slug / unslug

Return a slugged string or a string from a slugged value.

```coffee
slug 'Example string'
# return "example_string"
unslug 'example_string'
# return "Example string"
```
{%- endcapture -%}