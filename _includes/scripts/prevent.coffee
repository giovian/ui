$(document).on "click", "a.prevent-default", (e) -> e.preventDefault()
$(document).on "submit", "form.prevent-default", (e) -> e.preventDefault()

{%- capture api -%}
## Prevent default

Prevent default events for links and forms with a `.prevent-default`{:.language-sass} class.
{%- endcapture -%}