$('ul[github-api-url]').each ->
  # Variabiles
  ul = $ @
  url = ul.attr('github-api-url').replace 'repos', 'repos/{{ site.github.repository_nwo }}'
  out = ul.attr('github-api-out') || 'created_at'
  method = ul.attr('github-api-method') || 'GET'
  # Create link
  link = $('<a/>',
    text: ul.attr('github-api-text') || url
    href: "##{url}"
    'github-api-out': out
    'github-api-method': method
    'title': "#{method}: #{url} [#{out}]"
    'class': 'prevent-default'
  )
  # Link event and append
  link.on 'click', (e) -> request e
  ul.append $('<li/>').append(link)
  return # end widgets loop

request = (event) ->
  # Variabiles
  link = $ event.target
  list = link.parents 'ul'
  # Send request
  link.attr 'disabled', true
  api = $.ajax "{{ site.github.api_url }}/#{link.attr('href').replace '#', ''}",
    method: link.attr 'github-api-method'
  api.done (data, status) ->
    # Loop out properties
    for out in link.attr('github-api-out').split ','
      property = out.trim()
      raw_value = data[property] || 'ok'
      value = if Date.parse raw_value then time_diff raw_value else raw_value
      list.append "<li>#{property} <code>#{value}</code></li>"
    return # End API response process
  # Output error
  api.fail (request, status, error)-> list.append "<li>#{status}: <code>#{request.status}</code> #{request.responseJSON?.message || error}</li>"
  api.always -> link.removeAttr 'disabled'
  return # End API request
{%- capture api -%}
## GitHub API

The GitHub API REST requests interface is a LIST element `<ul>`{:.language-html} with `github-api-url` attribute.

```html
<ul github-api-url='repos/pages/builds'></ul>
```

**Attributes**

- `github-api-url`: the endpoint for the request.  
  `repos` will be replaced with the repository full name.
- `github-api-method`: default to `GET`
- `github-api-out`: comma separated list of response properties to show.  
  Default to `created_at`
- `github-api-text`: optional text for the link. Default to the endpoint
{%- endcapture -%}