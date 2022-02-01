{% if site.remote_theme %}
$('.api a').each ->
  link = $ @
  link.attr 'href', (i, h) ->
    h.replace '{{ site.github.repository_nwo }}', '{{ site.remote_theme | split: "@" | first }}'
  link.attr 'href', (i, h) ->
    if {{ site.remote_theme | split: "@" | size }} is 2
      h.replace 'blob/{{ site.github.public_repositories | where: "full_name", site.github.repository_nwo | first | map: "default_branch" | first }}', 'blob/{{ site.remote_theme | split: "@" | last }}'
  return
{% endif %}

{%- capture api -%}
## API links

Redirect links inside API widgets to the remote theme, these are links to documentation or to repository files.
{%- endcapture -%}