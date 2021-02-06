---
---

# Prevent default events
$("a.prevent-default").on "click", (e) -> e.preventDefault()
$("form.prevent-default").on "submit", (e) -> e.preventDefault()

# Fix inline <code> element without class
$(':not(pre) code').addClass 'highlighter-rouge highlight'

# String manipulation
unslug = (string) -> string.replace /_/g, " "
capitalize = (string) -> string.charAt(0).toUpperCase() + string.slice 1

# Get JSON data attribute
get_data = (element, data_name) -> JSON.parse(decodeURIComponent element.data data_name) || {}

$('a[set-color]').on 'click', ->
  color = $(@).attr 'set-color'
  $('html').removeClass 'color-blue color-green color-orange color-red'
  if color isnt 'default' then $('html').addClass "color-#{color}"
  return

$('a[set-accent]').on 'click', ->
  accent = $(@).attr 'set-accent'
  $('html').removeClass 'accent-blue accent-green accent-orange accent-red'
  if accent isnt 'default' then $('html').addClass "accent-#{accent}"
  return

{% include scripts/storage.coffee %}
{% include scripts/apply_family.coffee %}
{% include scripts/notification.coffee %}
{% include scripts/datetime.coffee %} # Needs: apply-family
{% include scripts/mode.coffee %} # Needs: apply-family
{% include scripts/login.coffee %} # Needs: storage, notification, apply_family
{% include scripts/details.coffee %}
{% include scripts/sidebar/toc.coffee %}
{% include scripts/api.coffee %} # Needs: notification
{% include scripts/parse.coffee %} # Needs: notification