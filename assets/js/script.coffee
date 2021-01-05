---
---

{% include_relative widgets/storage.coffee %}
{% include_relative widgets/busy.coffee %}
{% include_relative widgets/notification.coffee %}
{% include_relative widgets/login.coffee %}
{% include_relative widgets/mode.coffee %}
{% include_relative widgets/datetime.coffee %}

# Prevent default events
$("a.prevent-default").on "click", (e) -> e.preventDefault()
$("form.prevent-default").on "submit", (e) -> e.preventDefault()