process_pulls = (pulls) ->
  console.log pulls
  return # End process_pulls

open_pull = ->
  # <https://docs.github.com/en/rest/pulls/pulls#create-a-pull-request>
  post = "{{ site.github.api_url }}/repos/#{storage.get 'repository.parent'}/pulls"
  # Head: The name of the branch where your changes are implemented
  head = "#{storage.key.split('/')[0]}:#{storage.get 'repository.default_branch'}"
  # Base: The name of the branch you want the changes pulled into
  base = storage.get 'repository.default_branch'
  if confirm "#{post} - #{head}"
    console.log post, head
  return # End open pull