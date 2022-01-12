# Dispatch
checks = ->

  # Check latest build
  latest_build = $.get "#{github_api_url}/pages/builds/latest"
  latest_build.done (data) ->
    created_at = new Date(data.created_at).getTime() / 1000
    # Compare latest build created_at and site.time
    if data.status is 'built' and created_at > {{ site.time | date: "%s" }}
      # Refresh with the latest built creation unix time
      loc = window.location
      new_url = loc.origin + loc.pathname + '?created_at=' + data.created_at + loc.hash
      notification "<a href='#{new_url}'>New build</a>", '', true
    return # End latest callback

  # Check remote theme
  if '{{ site.remote_theme }}' isnt ''
    [remote, branch] = '{{ site.remote_theme }}'.split '@'
    ajax_data = if branch then {sha: branch} else {}
    version_url = "#{github_api_url}/contents/_includes/version.html"
    latest_tag = $.get "{{ site.github.api_url }}/repos/#{remote}/releases/latest",
      data: ajax_data
    latest_tag.done (data) ->
      get_version = $.get version_url
      get_version.done (version_file, status) ->
        # Compare online and hardcoded version
        if data.tag_name isnt Base64.decode version_file.content
          # Update hardcoded version
          update_version = $.ajax version_url,
            method: 'PUT'
            data: JSON.stringify
              message: 'Bump remote theme version'
              content: Base64.encode data.tag_name
              sha: version_file.sha
          update_version.done -> notification 'Remote theme release updated'
        return # End getting version file
      get_version.fail (request, status, error) ->
        # version don't exist 404
        if error is 'Not Found'
          # First PUT hardcoded version
          create_version = $.ajax version_url,
            method: 'PUT'
            data: JSON.stringify
              message: 'First time remote theme version'
              content: Base64.encode data.tag_name
          create_version.done -> notification 'First time theme release saved'
        return # End 404 first version PUT
      return # End remote TAG check

  # Schedule next check
  setTimeout checks, 60 * 1000

  return # End checks

# Start checks
if '{{ site.github.environment }}' isnt 'development' and login.logged_admin()
  setTimeout checks, 60 * 1000

{%- capture api -%}
## Updates

Updates are checked every minute after pageload, only if the user is logged as `admin`.

**Latest build**

Compare Jekyll `site.time` with GitHub latest built creation time.  
If they are different, show a notification link.

**Remote theme Latest Release Tag Name**  
Compare the remote theme latest release tag name with previous stored tag name.  
If they are different, show a notification.

This script is not active in `development` environment.
{%- endcapture -%}