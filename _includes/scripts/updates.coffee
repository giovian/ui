# Dispatch
updates = ->

  # Schedule next check
  setTimeout checks, 60 * 1000

  # Abort if browsing site
  if focus then return

  # Check latest build
  latest_url = github_api_url + "/pages/builds/latest"
  latest_build = $.get latest_url
  latest_build.done (data) ->
    data = cache data, latest_url
    created_at = +new Date(data.created_at) / 1000
    # Compare latest build created_at and site.time
    if data.status is 'built' and created_at > {{ site.time | date: "%s" }}
      loc = window.location
      new_url = loc.origin + loc.pathname + '?created_at=' + data.created_at + loc.hash
      # Refresh with the latest built creation unix time on tab blur
      if !focus then window.location.href = new_url
    return # End latest callback

  return # End checks

# Start checks, pages API is for authenticated users
if '{{ site.github.environment }}' isnt 'development' and login.logged()
  setTimeout updates, 60 * 1000

{%- capture api -%}
## Updates

Updates are checked every minute after pageload, only if window is blurred.

**Latest build**

Compare Jekyll `site.time` with GitHub latest built `created_at`.  
If they are different and the browser tab is blurred, refresh the page.

This script is not active in `development` environment.
{%- endcapture -%}