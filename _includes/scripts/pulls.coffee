# Process pull requests
# pulls: Non empty array of pull requests
# `site.github.environment` isnt `development`
# Repository is not a fork
# Logged role is `admin`
# `site.time` is ahead of builds
process_pulls = (pulls) ->
  for pull in pulls
    # Get a pull request
    # <https://docs.github.com/en/rest/pulls/pulls#get-a-pull-request>
    pull_url = "#{github_api_url}/pulls/#{pull.number}"
    console.log pull_url
    return
  return # End process_pulls

open_pull = ->
  # <https://docs.github.com/en/rest/pulls/pulls#create-a-pull-request>
  post = "{{ site.github.api_url }}/repos/#{storage.get 'repository.parent'}/pulls"
  # Head: The name of the branch where your changes are implemented
  head = "#{storage.key.split('/')[0]}:#{storage.get 'repository.default_branch'}"
  # Base: The name of the branch you want the changes pulled into
  base = storage.get 'repository.default_branch'
  if confirm "Open pull request in #{storage.get 'repository.parent'} from #{head}?"
    # Create a Pull request
    load =
      title: 'Create a pull request'
      body: "From #{head}"
      head: head
      base: base
    notification load.title
    open = $.ajax post,
      method: 'POST'
      data: JSON.stringify load
    open.done (data) ->
      notification "Pull ##{data.number} opened", 'green'
  return # End open pull