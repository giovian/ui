login =
  login_link: $ 'a.login-link'
  logout_link: $ 'a.logout-link'
  storage: () -> storage.get('login') || {}
  text: -> "Logged as #{login.storage()['user']} (#{login.storage()['role']})"

login.login_link.on 'click', (e) ->
  token = prompt "Paste a GitHub personal token"
  if !token then return
  storage.set 'login', {'token': token}
  notification 'Verifying'
  login.login_link.attr 'disabled', ''
  auth = $.get '{{ site.github.api_url }}/user'
  auth.done (data) ->
    storage.assign 'login', {'user': data.login, 'logged': new Date()}
    login.permissions()
    return # End token check
  auth.fail -> login.setLogin()
  true

login.permissions = ->
  notification 'Checking permissions'
  repo = $.get '{{ site.github.api_url }}/repos/{{ site.github.repository_nwo }}'
  repo.done (data) ->
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
  $('html').removeAttr 'user'
  storage.clear()
  apply_family()
  true

login.setLogout = ->
  $('html').addClass "role-#{login.storage()['role']} logged"
  $('html').attr 'user', login.storage()['user']
  login.login_link.removeAttr 'disabled'
  login.logout_link.attr 'title', login.text()
  apply_family()
  true

# Immediately Invoked Function Expressions
login.init = (-> if login.storage()['token'] then login.setLogout() else login.setLogin())()
{%- capture api -%}
## Login

Manage GitHub login and logout using `localStorage` and the relative links in the login widget.  

When logged, HTML will have a `.logged`{:.language-sass} class and the role classes `.role-admin`{:.language-sass} or `.role-guest`{:.language-sass} depending on write permissions of the logged user.
{%- endcapture -%}