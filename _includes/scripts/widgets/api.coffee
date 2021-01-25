$('[data-api]').each ->

  $container = $ @
  api = get_data $container, 'api'
  $results = $container.find('div:last-of-type')
  $title = $container.find("span:first-of-type")
  $link = $container.find('a:first-of-type')

  if api.execute then execute api else $link.on 'click', -> execute api

  execute = (api) ->
    $link.addClass 'disabled'
    $results.empty()
    call = $.ajax {
      url: api.url
      method: api.method || 'GET'
      headers: api.headers || {}
      data: api.data || {}
    }
    call.done (data, status) -> $results.append output populate api, data
    call.fail (request, status, error) -> notification "API #{status} #{error}", 'red', true
    call.always -> $link.removeClass('disabled')
    return

  populate = (api, data) ->
    elements = []
    if Array.isArray api.out
      property_array = api.out.map (property) -> property.split(' ').reduce ((acc, cur) -> acc[cur] ? 'Not found'), data
      elements.push property_array.map (out, index) -> [capitalize(unslug api.out[index]), out]
    if api.loop
      if api.loop.property
        elements.push data[api.loop.property].map (item, index) -> ["#{capitalize(unslug api.loop.property)} #{index+1}", populate(api.loop, item)].flat()
      else
        elements.push data.map (item, index) -> ["Items #{index+1}", populate(api.loop, item) ].flat()
    return elements

  output = (array) ->
    markup = $('<ul/>')
    for e in array
      markup.append e.map (i) ->
        return if typeof i[1] isnt 'object'
          if Date.parse i[1]
            span = $ '<span/>', {text: "#{i[1]}", datetime: i[1], replace: true}
            dateTime span
          else
            span = $('<span/>', {text: "#{i[1] ? 'Not found'}"})
          $('<li/>').append [
            $('<span/>', {text: "#{i[0]}: "})
            span
          ]
        else $('<li/>', {class: 'no-marker', text: i[0]}).append output i.slice 1
    return markup

  true