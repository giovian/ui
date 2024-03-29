---
order: 30
---

# Widgets
{:.no_toc}
- toc
{:toc}

> <https://jekyllrb.com/docs/>

{% include widgets/api.html %}
{% include widgets/api.html include="widgets/datetime" %}
{% assign now = 'now' | date: "%s" %}
{% assign minute = 60 %}
{% assign hour = minute | times: 60 %}
{% assign day = hour | times: 24 %}
{% assign week = day | times: 7 %}
{% assign month = day | times: 30 %}
{% assign year = week | times: 52 %}
{% assign future_minute = now | plus: minute %}
{% assign future_hour = now | plus: hour %}
{% assign future_day = now | plus: day %}
{% assign future_week = now | plus: week %}
{% assign future_month = now | plus: month %}
{% assign future_year = now | plus: year %}
{% assign past_minute = now | minus: minute %}
{% assign past_hour = now | minus: hour %}
{% assign past_day = now | minus: day %}
{% assign past_week = now | minus: week %}
{% assign past_month = now | minus: month %}
{% assign past_year = now | minus: year %}
**Basic**
- Default: {% include widgets/datetime.html %}
- Embed: {% include widgets/datetime.html embed=true %}
- Replace: {% include widgets/datetime.html replace=true %}
<div class="grid">
<div markdown=1>
**Future**
- Minute: {% include widgets/datetime.html replace=1 datetime=future_minute %}
- Hour: {% include widgets/datetime.html replace=1 datetime=future_hour %}
- Day: {% include widgets/datetime.html replace=1 datetime=future_day %}
- Week: {% include widgets/datetime.html replace=1 datetime=future_week %}
- Month: {% include widgets/datetime.html replace=1 datetime=future_month %}
- Year: {% include widgets/datetime.html replace=1 datetime=future_year %}
</div>
<div markdown=1>
**Past**
- Minute: {% include widgets/datetime.html replace=1 datetime=past_minute %}
- Hour: {% include widgets/datetime.html replace=1 datetime=past_hour %}
- Day: {% include widgets/datetime.html replace=1 datetime=past_day %}
- Week: {% include widgets/datetime.html replace=1 datetime=past_week %}
- Month: {% include widgets/datetime.html replace=1 datetime=past_month %}
- Year: {% include widgets/datetime.html replace=1 datetime=past_year %}
</div>
</div>
{% include widgets/api.html include='widgets/github_url' %}
{% include widgets/api.html include='widgets/github_link' %}
{% include widgets/api.html include='widgets/login' %}
{% include widgets/api.html include='widgets/schema' %}
{% include widgets/api.html include='widgets/document' %}
{% include widgets/api.html include='widgets/form' %}
{% include widgets/api.html include='widgets/csv-table' %}
{% include widgets/api.html include='widgets/csv-blocks' %}
{% include widgets/api.html include='widgets/csv-calendar' %}
{% include widgets/api.html include='widgets/csv-counter' %}
{% include widgets/api.html include='widgets/bar' %}
**Example**
```liquid
{% raw %}{% include widgets/bar.html labels='Default 25%, Light 15%, Border 15%, Green 20%, Red 15%, Off' titles=', bg-border, border-fg-secondary fg, green, red' classes=', bg-border, border-fg-secondary fg, green, red' widths='25%, 15%, 15%, 20%, 15%' %}{% endraw %}
```
{% include widgets/bar.html labels='Default 25%,Light 15%,Border 15%,Green 20%,Red 15%,Off' titles=',bg-border,border-fg-secondary fg,green,red' classes=',bg-border,border-fg-secondary fg,green,red' widths='25%,15%,15%,20%,15%' %}
{% include widgets/api.html include='widgets/toc' %}