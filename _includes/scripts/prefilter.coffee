# Ajax prefilter
$.ajaxPrefilter (options, ajaxOptions, request) ->

  # Fail function
  request.fail (request, status, error) ->
    notification "#{status}: #{request.status} #{request.responseJSON?.message || error}", 'red'

  # Add header options
  if options.url.startsWith '{{ site.github.api_url }}'
    # Recommended Accept header
    options.headers = {'Accept': 'application/vnd.github.v3+json'}
    # Check cached version
    if (ajaxOptions.type || options.method).toLowerCase() is 'get'
      entry = storage.get('github_api')?[options.url]
      # Set If-Modified-Since header
      if entry
        options.headers['If-Modified-Since'] = entry.ifModified
        options.ifModified = true
        options.cache = true
    # Check personal token
    if login.logged()
      # Add GitHub token
      options.headers['Authorization'] = "token #{storage.get 'login.token'}"

  return # end Prefilter

# Success function to save `last-modified`
$(document).ajaxSuccess (event, request, ajaxOptions, data) ->
  method = (ajaxOptions.type || ajaxOptions.method).toLowerCase()
  # Store data and last-modified
  if method is 'get' and data and request.getResponseHeader 'last-modified'
    storage.assign 'github_api', {"#{ajaxOptions.url}":
      ifModified: request.getResponseHeader 'last-modified'
      data: data
    }
  return # End ajax Success

{%- capture api -%}
## Ajax prefilter

- Show a notification in case of error
**For request to GitHub API**
- Set `Accept` header (and `Authorization` headers if user is logged)
- Set `If-Modified-Since` header if data are cached in storage
- Save `last-modified` response header for `get` requests
- Cache data for `get` requests
- Return cached data if possible
{%- endcapture -%}