github_api_url = '{{ site.github.api_url }}/repos/{{ site.github.repository_nwo }}'

# For every lists: create link for the request and append it as first item
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
  ul.append $('<li/>').append(link)
  return # end widgets loop

$(document).on 'click', 'a[github-api-out]', (e) -> github_api_request e

# Given a data array and an array of property names, return a list items array
github_api_response_list = (data, out_array) ->
  li_array = []
  for out, j in out_array
    property = out.trim().replace /\[(.+)\]/, ''
    raw_value = reduce_object property, data
    if typeof raw_value is 'string'
      if Date.parse raw_value then raw_value = time_diff raw_value
      if raw_value.startsWith 'https://github.com/'
        raw_value = "<a href='#{raw_value}'>#{raw_value.slice 19}</a>"
    if Array.isArray raw_value
      for d, i in raw_value
        li_array.push "<li>Item #{i}</li>"
        sublist = github_api_response_list d, out.trim().match(/\[(.+)\]/)[1].split(',')
        inner_list = $('<ul/>').append sublist
        li_array.push inner_list
    else li_array.push "<li>#{property} <code>#{raw_value}</code></li>"
  return li_array # End response list

github_api_request = (event) ->
  # Variabiles
  link = $ event.target
  list = link.parents 'ul'
  # Send request
  link.attr 'disabled', true
  ajax_url = "{{ site.github.api_url }}/#{link.attr('href').replace '#', ''}"
  api = $.ajax ajax_url,
    method: link.attr 'github-api-method'
  api.done (data) ->
    data = cache data, ajax_url
    # For every data (object or array) append a list looping out properties
    if !Array.isArray data then data = [data]
    data.map (d) ->
      list.append github_api_response_list d, link.attr('github-api-out').split ','
    return # End API response process

  # Output error
  api.fail (request, status, error) -> list.append "<li>#{status}: <code>#{request.status}</code> #{request.responseJSON?.message || error}</li>"
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
- `github-api-text`: text for the link. Default to the endpoint
{%- endcapture -%}