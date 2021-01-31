login =
  login_link: $ 'a.login-link'
  logout_link: $ 'a.logout-link'
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
  storage.set 'login', {'token': token}
  notification 'Verifying'
  auth = $.get '{{ site.github.api_url }}/user'
  auth.done (data, status) ->
    storage.assign 'login', {'user': data.login, 'logged': new Date()}
    login.permissions()
    return
  auth.fail (request, status, error) ->
    notification "Login #{status}, #{error}", 'red', true
    login.setLogin()
    return
  true

login.permissions = ->
  notification 'Checking permissions'
  repo = $.get '{{ site.github.api_url }}/repos/{{ site.github.repository_nwo }}'
  repo.fail (request, status, error) -> notification "Permissions #{status} #{error}", 'red'
  repo.done (data, status) ->
    storage.assign 'login', {
      "role": (if data.permissions.admin then 'admin' else 'guest')
      'fork': data.fork
      'parent': data.parent?.full_name?
    }
    return
  repo.always () ->
    login.setLogout()
    notification login.text(), 'green', true
    return
  true

login.logout_link.on 'click', (e) ->
  e.preventDefault()
  login.setLogin()
  notification 'Logged out', false, true
  true

login.setLogin = ->
  $('html').removeClass 'role-admin role-guest logged'
  $.ajaxSetup { headers: {"Accept": "application/vnd.github.v3+json"} }
  storage.clear 'login'
  apply_family()
  true

login.setLogout = ->
  $('html').addClass "role-#{login.storage()['role']} logged"
  login.logout_link.attr 'title', login.text()
  $.ajaxSetup { headers:
    "Authorization": "token #{login.storage()['token']}"
    "Accept": "application/vnd.github.v3+json"
  }
  apply_family()
  true

# Immediately Invoked Function Expressions
login.init = (-> if login.storage()["token"] then login.setLogout() else login.setLogin())()