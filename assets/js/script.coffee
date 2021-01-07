---
---

{% include scripts/storage.coffee %}
{% include scripts/busy.coffee %}
{% include scripts/notification.coffee %}
{% include scripts/login.coffee %}
{% include scripts/mode.coffee %}
{% include scripts/datetime.coffee %}

# Prevent default events
$("a.prevent-default").on "click", (e) -> e.preventDefault()
$("form.prevent-default").on "submit", (e) -> e.preventDefault()

# Fix inline <code> element without class
$(':not(pre) code').addClass 'highlighter-rouge highlight'