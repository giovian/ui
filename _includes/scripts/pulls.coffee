process_pulls = (pulls) ->
  console.log pulls
  return # End process_pulls

open_pull = ->
  console.log 'head', "#{storage.key.split('/')[0]}:#{storage.get 'repository.default_branch'}", 'base', storage.get 'repository.default_branch'
  return # End open pull