$('[data-parse]').each ->

  $container = $ @
  parse = get_data $container, 'parse'
  $link = $container.find('a:first-of-type')
  $results = $container.find('div:last-of-type')
  cors_url = "https://afternoon-hollows-35729.herokuapp.com/"

  execute = (parse) ->
    $link.addClass 'disabled'
    $results.empty()
    call = $.ajax {
      url: cors_url + parse.url
      cache: false
      # method: api.method || 'GET'
      headers: parse.headers || null
      # data: api.data || null
    }
    call.done (data, status) -> console.log data
    call.fail (request, status, error) -> notification "PARSE #{status} #{error}", 'red', true
    call.always -> $link.removeClass('disabled')
    return

  if parse.execute then execute parse else $link.on 'click', -> execute parse

  return