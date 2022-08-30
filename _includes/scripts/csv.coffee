update_csv = (document_file, data) ->

  # Update eventual CSV table
  $(".csv-table[data-file='#{document_file}']").each ->
    fill_table $(@), data
    return # End tables update

  # Update eventual CSV blocks
  $(".csv-blocks[data-file='#{document_file}']").each ->
    fill_blocks $(@), data
    return # End blocks update

  # Update eventual CSV counter
  $(".bar[data-file='#{document_file}']").each ->
    fill_counter $(@), data
    return # End counter update

  # Update eventual CSV calendar
  $(".csv-calendar[data-file='#{document_file}']").each ->
    fill_calendar $(@), data
    return # End blocks update

  return # End updates tablesand blocks

#
# Load Document for CSV
# --------------------------------------
load_schema_document = (el) ->
  element = $ el
  element.attr 'disabled', ''

  # Get file names
  document_url = "#{github_api_url}/contents/_data/#{element.attr 'data-file'}.csv"
  schema_url = "#{github_api_url}/contents/_data/#{element.attr 'data-file'}.schema.json"

  # Load document
  get_document = $.get document_url
  get_document.done (data) ->
    data = cache document_url, data
    update_csv element.attr('data-file'), data
    return # End get document
  get_document.always -> element.removeAttr 'disabled'

  return # End CSV tables loop

#
# CSV elements startup
# --------------------------------------
$('[class*="csv-"][data-file], .bar[data-file]').each (i, element) ->
  if i is 0 then load_schema_document element