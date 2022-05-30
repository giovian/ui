process_pulls = (pulls) ->
  console.log pulls
  return # End process_pulls

open_pull = ->
  # <https://docs.github.com/en/rest/pulls/pulls#create-a-pull-request>
  # Check if already opened
  console.log "POST", "{{ site.github.api_url }}/repos/#{storage.get 'repository.parent'}/pulls"
  console.log 'head', "#{storage.key.split('/')[0]}:#{storage.get 'repository.default_branch'}", 'base', storage.get 'repository.default_branch'
  return # End open pull