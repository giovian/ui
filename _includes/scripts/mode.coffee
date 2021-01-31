$('html').addClass "mode-#{storage.get('mode') || 'light'}"

# Toggle
$("a.toggle-mode-link").on 'click', (e) ->
  html = $('html').toggleClass 'mode-dark mode-light'
  storage.set 'mode', if html.hasClass 'mode-dark' then 'dark' else 'light'
  apply_family()
  true