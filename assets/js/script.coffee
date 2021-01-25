---
---

# Prevent default events
$("a.prevent-default").on "click", (e) -> e.preventDefault()
$("form.prevent-default").on "submit", (e) -> e.preventDefault()

# Fix inline <code> element without class
$(':not(pre) code').addClass 'highlighter-rouge highlight'

# apply-if-parent apply-if-children
# Will not work on runtime changes
$('[apply-if-parent]').each ->
  [apply, match] = $(@).attr('apply-if-parent').split(':')
  if $(@).parents(match).length then $(@).addClass apply
  return
$('[apply-if-children]').each ->
  [apply, match] = $(@).attr('apply-if-children').split(':')
  if $(@).find(match).length then $(@).addClass apply
  return

unslug = (string) -> string.replace "_", " "
capitalize = (string) -> string.charAt(0).toUpperCase() + string.slice 1
get_data = (element, data_name) -> JSON.parse(decodeURIComponent element.data data_name) || {}

{% include scripts/storage.coffee %}
{% include scripts/notification.coffee %}
{% include scripts/widgets/login.coffee %}
{% include scripts/widgets/mode.coffee %}
{% include scripts/widgets/datetime.coffee %}
{% include scripts/widgets/api.coffee %}
