# Dispatch
updates = ->

  # Schedule next check
  setTimeout updates, 60 * 1000

  # Abort if browsing site or rate_limit low
  if focus or storage.get('rate_limit') < 25 then return

  # Request builds list if authenticated or commit list if guest
  latest_url = github_api_url + if login.logged() then '/pages/builds' else '/commits'
  latest_build = $.get latest_url
  latest_build.done (data) ->
    data = cache data, latest_url
    # Get latest build/commit date and SHA
    [latest_date, latest_sha] = if login.logged()
      # Take the first 'built' build
      element = data.filter((build) -> build.status is 'built')[0]
      [element.created_at, element.commit]
    else [data[0].commit.author.date, data[0].sha]
    # Compare latest build created_at or commit date, and site.time
    if +new Date(latest_date) / 1000 > {{ site.time | date: "%s" }}
      loc = window.location
      new_url = loc.origin + loc.pathname + '?latest=' + latest_date + loc.hash
      # Refresh with the latest repository action
      window.location.href = new_url
    else
      # Build is updated, check if is a fork and user is admin
      if login.storage()['role'] is 'admin' and storage.get 'repository.fork'
        # Get upstream SHA
        upstream_api = "{{ site.github.api_url }}/repos/#{storage.get 'repository.parent'}/commits"
        upstream = $.get upstream_api
        upstream.done (data) ->
          data = cache data, upstream_api
          # Compare local and remote SHAs
          if latest_sha isnt data[0].sha
            # Sync with upstream
            sync = $.ajax "#{github_api_url}/merge-upstream",
              method: 'POST'
              data: JSON.stringify {"branch": "#{storage.get 'repository.default_branch'}"}
            sync.done (data) -> notification "Synched with upstream branch"
          return # End upstream

    return # End latest_build

  return # End checks

# Start checks, pages API is for authenticated users
if '{{ site.github.environment }}' isnt 'development'
  setTimeout updates, 60 * 1000

{%- capture api -%}
## Updates

Updates are checked every minute after pageload, only if window is blurred and _rate limit_ is more than 25.

**Latest build**

Compare Jekyll `site.time` with GitHub latest built `created_at` (or latest commit date if user is not authenticated).  
If they are different and the browser tab is blurred, refresh the page.

This script is not active in `development` environment.
{%- endcapture -%}