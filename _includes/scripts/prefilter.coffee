# Ajax prefilter
$.ajaxPrefilter (options, ajaxOptions, request) ->

  # Abort if offline
  if !navigator.onLine
    request.abort()
    notification "error: browser is offline", 'red'
    return # end Offline check

  # Remove cache if localStorage too big (more than 150k characters)
  if localStorage.getItem(storage.key).length > 150000
    storage.clear 'github_api'

  # Fail function
  request.fail (request, status, error) ->
    if status isnt 'canceled'
      notification "#{status}: #{request.status} #{request.responseJSON?.message || error}", 'red'
    return # End fail handler

  # Add header options
  if options.url.startsWith '{{ site.github.api_url }}'
    # Recommended Accept header
    options.headers = {'Accept': 'application/vnd.github.v3+json'}
    # Check cached version
    if (ajaxOptions.type || options.method).toLowerCase() is 'get'
      entry = storage.get('github_api')?[options.url]
      # Set If-Modified-Since and If-None-Match headers
      if entry
        # Request successful only if the response has changed
        options.ifModified = true
        # Add `etag` and `ifmodified` to the request headers if presents
        if entry.etag?
          options.headers['If-None-Match'] = entry.etag
        if entry.ifModified?
          options.headers['If-Modified-Since'] = entry.ifModified
    # Add GitHub token
    if login.logged()
      options.headers['Authorization'] = "token #{storage.get 'login.token'}"

  return # end Prefilter

# Success function to save `last-modified`
$(document).ajaxSuccess (event, request, ajaxOptions, data) ->
  url = ajaxOptions.url

  # Save only GET from GitHub
  if (ajaxOptions.type || ajaxOptions.method).toLowerCase() is 'get' and url.startsWith '{{ site.github.api_url }}'

    # Save rate_limit remaining if present
    if request.getResponseHeader 'x-ratelimit-remaining'
      storage.set 'rate_limit', +request.getResponseHeader 'x-ratelimit-remaining'

    # Store data and properties if is a GET from GitHub
    if data

      # Store Data
      storage.assign 'github_api', "#{url}":
        data: data

      # Store properties
      if request.getResponseHeader 'last-modified'
        storage.assign 'github_api', "#{url}":
          ifModified: request.getResponseHeader 'last-modified'
      if request.getResponseHeader 'etag'
        storage.assign 'github_api', "#{url}":
          etag: request.getResponseHeader 'etag'
  return # End ajax Success

{%- capture api -%}
## Ajax prefilter

- Show a notification if request fail.

**For request to GitHub API**

- Set `Accept` header (and `Authorization` headers if user is logged)

**For `get` requests**

- Set `If-None-Match` or `If-Modified-Since` headers if data are cached in storage
- Save `last-modified` and `etag` response headers
- Cache data
{%- endcapture -%}