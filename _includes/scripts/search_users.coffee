$('#search-users').on 'click', (e) ->
  q='remote_theme+giovian+ui+extension:yml+extension:yaml+filename:_config.yml+filename:_config.yaml'
  q1='remote_theme+giovian+ui'
  # https://docs.github.com/en/free-pro-team@latest/rest/reference/search#text-match-metadata
  $.ajaxSetup { headers:
    "Authorization": "token #{storage.get('login').token}"
    "Accept": "application/vnd.github.v3.text-match+json"
  }
  notification 'Searching'
  search = $.get '{{ site.github.api_url }}/search/code', {q: q1}
  search.always () -> notification 'Done', null, true
  search.done (data, status) ->
    out = [] 
    out.push status
    out.push "total_count #{data.total_count}"
    out.push "incomplete_results #{data.incomplete_results}"
    for d, i in data.items
      out.push "data number #{i}"
      out.push d.repository.full_name
      out.push d.path
      out.push d.repository.description
      for m, j in d.text_matches
        out.push "match number #{j}"
        out.push "object_type #{m.object_type}"
        out.push "property #{m.property}"
        out.push m.fragment
        for matches, k in m.matches
          out.push "string number #{k}:"
          out.push matches.text
    console.log out.join "\n"
    return
  return