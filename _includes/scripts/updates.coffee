# Dispatch
updates = ->

  # Schedule next check
  setTimeout updates, ms.minute()

  # Abort rate_limit low
  if storage.get('rate_limit') < 25
    notification "Rate limit low for updates: #{storage.get 'rate_limit'}"
    return

  # Request builds list if authenticated or commit list if guest
  latest_url = github_api_url + if login.logged() then '/pages/builds' else '/commits'
  latest_build = $.get latest_url
  latest_build.done (data) ->
    data = cache data, latest_url
    # Get latest build/commit date and SHA
    [latest_date, latest_sha] = if login.logged()
      # Take the first 'built' build
      element = data.filter((build) -> build.status is 'built')[0]
      [+new Date(element.created_at), element.commit]
    else [+new Date(data[0].commit.author.date), data[0].sha]
    # Compare latest build created_at or commit date, and site.time
    if latest_date / 1000 > {{ site.time | date: "%s" }}
      # There was a build or a commit after site.time
      loc = window.location
      new_url = loc.origin + loc.pathname + '?latest=' + latest_date + loc.hash
      # If browser is unfocused refresh page
      if !focus then window.location.href = new_url
    else
      # Build is updated, check sync and pulls for admin users
      if login.storage()['role'] is 'admin'
        # If it is a fork check if need sync or pull
        if storage.get 'repository.fork'
          # Get upstream commits
          upstream_api = "{{ site.github.api_url }}/repos/#{storage.get 'repository.parent'}/commits"
          upstream = $.get upstream_api
          upstream.done (data) ->
            data = cache data, upstream_api
            # Compare SHAs
            if latest_sha isnt data[0].sha
              # If repository is behind, need sync
              if latest_date < +new Date(data[0].commit.author.date)
                # Sync with upstream
                # https://docs.github.com/en/rest/branches/branches#sync-a-fork-branch-with-the-upstream-repository
                sync = $.ajax "#{github_api_url}/merge-upstream",
                  method: 'POST'
                  data: JSON.stringify {"branch": "#{storage.get 'repository.default_branch'}"}
                sync.done (data) -> notification 'Synched with upstream branch', 'green'
              # If repository is ahead, need pull
              else notification "Needs pull #{latest_date} > #{data[0].commit.author.date}"
            return # End upstream
        # Not a fork, check pulls
        else
          pulls_url = github_api_url + '/pulls'
          pulls = $.get pulls_url
          pulls.done (data) ->
            data = cache data, pulls_url
            console.log data.length, data
            return # End pulls

    return # End latest_build

  return # End checks

# Start checks, `pages` API is for authenticated users
if '{{ site.github.environment }}' isnt 'development'
  setTimeout updates, ms.minute()

{%- capture api -%}
## Updates

Updates are checked every minute after pageload, only if window is blurred and _rate limit_ is more than 25.

Compare Jekyll `site.time` with GitHub latest built `created_at` (or latest commit `author.date` if user is not authenticated). If they are different and the browser tab is blurred, refresh the page with a search string like `?latest=YYYY-MM-DDTHH:MM:SSZ`.  

If the repository is a fork and logged user is admin, compare branch SHA with upstream and sync if different.

This script is not active in `development` environment.
{%- endcapture -%}