---
---

# HELPERS

{% include scripts/prevent.coffee %}        # Prevent default events for links and forms
{% include scripts/storage.coffee %}        # Hashed storage system for localStorage
{% include scripts/apply_family.coffee %}   # Apply classes to parents/childrens
{% include scripts/datetime.coffee %}       # Use apply_family
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
{% include scripts/updates.coffee %}        # Check repository and remote theme updates
{% include scripts/tab.coffee %}            # Manage TABs
{% include scripts/form.coffee %}           # Form engine
{% include scripts/schema.coffee %}         # Manage array schema engine
{% include scripts/document.coffee %}       # Manage document from schema
{% include scripts/csv_table.coffee %}      # Table from CSV data file
{% include scripts/csv_blocks.coffee %}     # Blocks from CSV data file
{% include scripts/csv_calendar.coffee %}     # Calendar from CSV data file

# CUSTOM

{% include scripts/custom.coffee %}         # Custom file, empty by default
