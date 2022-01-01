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

# WIDGETS

{% include scripts/notification.coffee %}   # Use datetime
{% include scripts/login.coffee %}          # Use notification, apply_family, storage
{% include scripts/detail.coffee %}         # Use storage
{% include scripts/github_api.coffee %}     # Perform GitHub API REST requests

# FUNCTIONS

{% include scripts/focus.coffee %}          # Check website browser tab is focused
{% include scripts/inview.coffee %}         # In view Observer
{% include scripts/updates.coffee %}        # Check repository and remote theme updates
{% include scripts/tab.coffee %}            # Manage TABs
{% include scripts/form.coffee %}           # Form engine
{% include scripts/schema.coffee %}         # Manage array schema engine
{% include scripts/document.coffee %}       # Manage document from schema

# CUSTOM

{% include scripts/custom.coffee %}         # Custom file, empty by default
