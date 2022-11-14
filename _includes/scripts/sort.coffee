sort = (container) ->
  sorted = container.find('[sort]').sort (a, b) ->
    value_a = $(a).attr 'sort'
    value_b = $(b).attr 'sort'
    if value_a is value_b then return 0
    return if value_a > value_b then 1 else -1
  container.find('[sort]').remove()
  container.append sorted
  return

$('[sort]').parent().each () -> sort $ @