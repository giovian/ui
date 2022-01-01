# Dispatch
checks = ->

  # Check latest build
  latest = $.get '{{ site.github.api_url }}/repos/{{ site.github.repository_nwo }}/pages/builds/latest'
  latest.done (data) ->
    created_at = new Date(data.created_at).getTime() / 1000
    # Compare latest build created_at and site.time
    if data.status is 'built' and created_at > {{ site.time | date: "%s" }}
      # Refresh with the latest built creation unix time
      loc = window.location
      new_url = loc.origin + loc.pathname + '?created_at=' + data.created_at + loc.hash
      notification "<a href='#{new_url}'>New build</a>", '', true
    return # End latest callback

  # Check remote theme, if used
  if '{{ site.remote_theme }}' isnt ''
    [remote, branch] = '{{ site.remote_theme }}'.split '@'
    ajax_data = if branch then {sha: branch} else {}
    latest = $.get "{{ site.github.api_url }}/repos/#{remote}/commits",
      data: ajax_data
    latest.done (data) ->
      # Compare online and stored remote commit SHA
      if data[0].sha isnt storage.get 'repository.remote_sha'
        # Update SHA on storage
        storage.assign 'repository', {remote_sha: data[0].sha}
        # Request a build
        notification 'New remote theme SHA', '', true
      return # End remote SHA check

  # Schedule next check
  setTimeout checks, 60 * 1000

  return # End checks

# Start checks
if '{{ site.github.environment }}' isnt 'development' and $('html').hasClass 'role-admin'
  setTimeout checks, 60 * 1000

{%- capture api -%}
## Updates

Updates are checked every minute after pageload, only if the user is logged as `admin`.  

**Latest build**  
Compare Jekyll `site.time` with GitHub latest built creation time.  
If they are different, show a notification link.  

**Remote theme SHA**  
Compare the remote theme latest commit with previous stored SHA.  
If they are different, show a notification.  

This script is not active in `development` environment.
{%- endcapture -%}