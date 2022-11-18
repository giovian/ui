---
---

# LOAD JEKYLL DATA
{% include scripts/sort.coffee %}

# CITATIONS
$('[cite]:not([title])').each -> $(@).attr 'title', $(@).attr('cite')

# HELPERS

{% include scripts/prevent.coffee %}        # Prevent default events for links and forms
{% include scripts/storage.coffee %}        # Hashed storage system for localStorage
{% include scripts/datetime.coffee %}       # Relative time functions
{% include scripts/prefilter.coffee %}      # Prefilter for Ajax calls
{% include scripts/toc.coffee %}            # Move toc to sidebar
{% include scripts/slug.coffee %}           # Function for string slug
{% include scripts/api_links.coffee %}      # Redirect API links on remote

# WIDGETS

{% include scripts/notification.coffee %}   # Use datetime
{% include scripts/github_api.coffee %}     # Perform GitHub API REST requests
{% include scripts/login.coffee %}          # Use notification, apply_family, storage
{% include scripts/detail.coffee %}         # Use storage

# FUNCTIONS

{% include scripts/focus.coffee %}          # Check website browser tab is focused
{% include scripts/inview.coffee %}         # In view Observer
{% include scripts/pulls.coffee %}          # Open or process Pulls
{% include scripts/updates.coffee %}        # Check site builds updates
{% include scripts/flipper.coffee %}        # Manage Flippers

# FORMS and DATA

{% include scripts/form.coffee %}           # Form engine
{% include scripts/csv.coffee %}            # Manage CSV widgets
{% include scripts/schema.coffee %}         # Manage array schema engine
{% include scripts/document.coffee %}       # Manage document from schema
{% include scripts/csv_table.coffee %}      # Table from CSV data file
{% include scripts/csv_blocks.coffee %}     # Blocks from CSV data file
{% include scripts/csv_calendar.coffee %}   # Calendar from CSV data file
{% include scripts/csv_counter.coffee %}    # Counter from CSV data file

# CUSTOM

{% include scripts/custom.coffee %}         # Custom file, empty by default
