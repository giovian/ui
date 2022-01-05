github_api_url = '{{ site.github.api_url }}/repos/{{ site.github.repository_nwo }}'

$('ul[github-api-url],ul[github-api-url-repo]').each ->
  # Variabiles
  ul = $ @
  url = ul.attr('github-api-url') || "repos/{{ site.github.repository_nwo }}/#{ul.attr 'github-api-url-repo'}"
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
    # Check if is Array
    if Array.isArray data
      # Loop array
      for d, i in data
        list.append "<li>Item #{i}</li>"
        inner_list = $ '<ul/>'
        # Loop out properties
        for out in link.attr('github-api-out').split ','
          property = out.trim()
          raw_value = reduce_object(property, d)
          value = if typeof raw_value is 'string' and Date.parse raw_value
              time_diff raw_value
            else raw_value
          inner_list.append "<li>#{property} <code>#{value}</code></li>"
        list.append inner_list
    else
      for out in link.attr('github-api-out').split ','
        property = out.trim()
        raw_value = reduce_object(property, data)
        value = if typeof raw_value is 'string' and Date.parse raw_value
            time_diff raw_value
          else raw_value
        list.append "<li>#{property} <code>#{value}</code></li>"

    return # End API response process

  # Output error
  api.fail (request, status, error)-> list.append "<li>#{status}: <code>#{request.status}</code> #{request.responseJSON?.message || error}</li>"
  api.always -> link.removeAttr 'disabled'
  return # End API request

{%- capture api -%}
## GitHub API

The GitHub API REST requests interface is a LIST element `<ul>`{:.language-html} with `github-api-url` or `github-api-url-repo` attribute.

If the response is an array, the output is a nested list.
```html
<ul github-api-url='rate_limit'></ul>
<ul github-api-url-repo='pages/builds'></ul>
```

**Attributes**

- `github-api-url`: endpoint for the request.  
- `github-api-url-repo`: endpoint for the request for the present repository {{ site.github.repository_nwo }}.  
- `github-api-method`: default to `GET`
- `github-api-out`: comma separated list of response properties to show.  
  Default to `created_at`
- `github-api-text`: optional text for the link. Default to the endpoint
{%- endcapture -%}