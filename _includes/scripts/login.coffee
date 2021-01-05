login =
  login_link: $ 'a.login-link'
  logout_link: $ 'a.logout-link'
  logged_user: $ 'span.logged-user'
  storage: () -> storage.get('login') || {}
  text: -> "Logged as #{login.storage()['user']} (#{login.storage()['role']})"

login.login_link.on 'click', (e) ->
  e.preventDefault()
  token = prompt "Paste a GitHub personal token"
  if !token then return
  $.ajaxSetup { headers:
    "Authorization": "token #{token}"
    "Accept": "application/vnd.github.v3+json"
  }
  storage.set 'login', Object.assign(login.storage(), {'token': token})
  busy login.login_link, true
  auth = $.get '{{ site.github.api_url }}/user'
  auth.done (data, status) ->
    storage.set 'login', Object.assign(login.storage(), {'user': data.login, 'logged': new Date()})
    login.permissions()
    return
  auth.fail (request, status, error) ->
    notification "Login #{status} #{error}", 'red'
    login.setLink 'login'
    return
  true

login.permissions = ->
  repo = $.get '{{ site.github.api_url }}/repos/{{ site.github.repository_nwo }}'
  repo.fail (request, status, error) -> notification "Permissions #{status} #{error}", 'red'
  repo.done (data, status) ->
    storage.set 'login', Object.assign(login.storage(), {"role": (if data.permissions.admin then 'admin' else 'guest'), 'fork': data.fork, 'parent': data.parent?.full_name?})
    return
  repo.always () ->
    login.setLink 'logout'
    notification login.text(), 'green'
    return
  true

login.logout_link.on 'click', (e) ->
  e.preventDefault()
  login.setLink 'login'
  notification 'Logged out', 'blue'
  true

login.setLink = (status) ->
  busy login.login_link, false
  if status is 'logout'
    login.logged_user.html "#{login.storage()['user']} &#x25BE;"
    $('html').addClass "role-#{login.storage()['role']} logged"
  if status is 'login'
    storage.clear 'login'
    $.ajaxSetup {}
    $('html').removeClass 'role-admin role-guest logged'
  true


login.init = (->
  if login.storage()["token"]
    $.ajaxSetup { headers:
      "Authorization": "token #{login.storage()['token']}"
      "Accept": "application/vnd.github.v3+json"
    }
    login.setLink 'logout'
  else
    login.setLink 'login'
  true
)()