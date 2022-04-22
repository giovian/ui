login =
  login_link: $ 'a.login-link'
  logout_link: $ 'a.logout-link'
  storage: () -> storage.get('login') || {}
  text: -> "Logged as #{login.storage()['user']} (#{login.storage()['role']})"

login.logged = -> storage.get('login.token')

login.login_link.on 'click', (e) ->
  token = prompt "Paste a GitHub personal token"
  if !token then return
  storage.set 'login', {'token': token}
  notification 'Verifying'
  login.login_link.attr 'disabled', ''
  user_url = '{{ site.github.api_url }}/user'
  auth = $.get user_url
  auth.done (data) ->
    data = cache data, user_url
    storage.assign 'login', {'user': data.login, 'logged': new Date()}
    login.permissions()
    return # End token check
  auth.fail -> login.setLogin()
  true

login.permissions = ->
  notification 'Checking permissions'
  repo = $.get github_api_url
  repo.done (data) ->
    data = cache data, github_api_url
    storage.assign('login',
      role: (if data.permissions.admin then 'admin' else 'guest')
    ).assign 'repository',
      fork: data.fork
      parent: data.parent?.full_name?
    return # End permission check
  repo.always ->
    login.setLogout()
    notification login.text(), 'green'
    return # End login process
  true

login.logout_link.on 'click', ->
  login.setLogin()
  notification 'Logged out'
  true

login.setLogin = ->
  $('html').removeClass 'role-admin role-guest logged'
  $('html').addClass 'unlogged'
  login.login_link.removeAttr 'disabled'
  storage.clear('login').clear 'repository'
  true

login.setLogout = ->
  $('html').removeClass 'unlogged'
  $('html').addClass "role-#{login.storage()['role']} logged"
  login.login_link.removeAttr 'disabled'
  login.logout_link.attr 'title', login.text()
  true

# Immediately Invoked Function Expressions
login.init = (-> if login.storage()['token'] then login.setLogout() else login.setLogin())()
{%- capture api -%}
## Login

Manage GitHub login and logout using `localStorage` and the relative links in the login widget.  

HTML will have a `.logged`{:.language-sass} or `.unlogged`{:.language-sass} class, and the role class `.role-admin`{:.language-sass} or `.role-guest`{:.language-sass} depending on write permissions of the logged user.
{%- endcapture -%}