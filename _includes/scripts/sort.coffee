# Element with `sort` attribute will be sorted in their parent element
# by the comparison of `sort` values.
# Default sort direction is `asc` (small to big)
# Parent element can have attribute `data-sort` being `desc`
sort = (container) ->
  multi = if container.data('sort') is 'desc' then -1 else 1
  sorted = container.find('[sort]').sort (a, b) ->
    value_a = $(a).attr 'sort'
    value_b = $(b).attr 'sort'
    if value_a is value_b then return 0
    return if value_a > value_b then multi else -multi
  container.find('[sort]').remove()
  container.append sorted
  return

$('[sort]').parent().each () -> sort $ @