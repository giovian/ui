# Ajax prefilter
$.ajaxPrefilter (options, ajaxOptions, request) ->

  # Fail function
  request.fail (request, status, error) -> notification "#{status}: #{request.status} #{request.responseJSON?.message || error}", 'red'

  # Add header options
  if options.url.startsWith '{{ site.github.api_url }}'
    # Recommended Accept header
    options.headers = {'Accept': 'application/vnd.github.v3+json'}
    # Check personal token
    if storage.get 'login.token'
      # Add GitHub token
      options.headers['Authorization'] = "token #{storage.get 'login.token'}"

  return # end Prefilter

{%- capture api -%}
## Ajax prefilter

- Set `Accept` and `Authorization` headers for request to GitHub API.
- Show a notification in case of error.
{%- endcapture -%}