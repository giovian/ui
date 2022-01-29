console.log 'replace {{ site.github.repository_nwo }} with {{ site.remote_theme | split: "@" | first }}'
console.log 'replace blob/{{ site.github.public_repositories | where: "full_name", site.github.repository_nwo | first | map: "default_branch" | first }}/ with blob/{{ site.remote_theme | split: "@" | last }}/'
{% if site.remote_theme %}
$('.api a').each ->
  link = $ @
  console.log link.attr 'href'
  return
{% endif %}

{%- capture api -%}
## API links

Redirect links inside API widgets to the remote theme, these are links to documentation or to repository files.
{%- endcapture -%}