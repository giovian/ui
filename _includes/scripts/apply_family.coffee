# apply-if-parent apply-if-children
# Will not work on runtime changes
apply_family = () ->
  $('[apply-if-parent]').each ->
    [apply, match] = $(@).attr('apply-if-parent').split ':'
    $(@).removeClass apply
    if $(@).parents(match).length then $(@).addClass apply
    return
  $('[apply-if-children]').each ->
    [apply, match] = $(@).attr('apply-if-children').split ':'
    $(@).removeClass apply
    if $(@).find(match).length then $(@).addClass apply
    return
  true
