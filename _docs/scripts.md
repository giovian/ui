---
order: 3
---

# Scripts

## Login

To show login/logout widget in the top navigation, set liquid variabile `login: true`, default is `false`.  
Can be set for specific pages in _front matter_ or for every page in the `_config` file defaults.

<div class="grid">
  <div markdown=1>
```yml
# _config.yml
defaults:
  - scope:
      path: ''
    values:
      login: true
```
  </div>
  <div markdown=1>
```yml
# Page front matter
---
login: true
---
```
  </div>
</div>

## Datetime

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
- Empty {% include widgets/datetime.html %}
- Embed {% include widgets/datetime.html embed=true %}
- Replace {% include widgets/datetime.html replace=true %}

**Future**
- Minute {% include widgets/datetime.html replace=1 datetime=future_minute %}
- Hour {% include widgets/datetime.html replace=1 datetime=future_hour %}
- Day {% include widgets/datetime.html replace=1 datetime=future_day %}
- Week {% include widgets/datetime.html replace=1 datetime=future_week %}
- Month {% include widgets/datetime.html replace=1 datetime=future_month %}
- Year {% include widgets/datetime.html replace=1 datetime=future_year %}

**Past**
- Minute {% include widgets/datetime.html replace=1 datetime=past_minute %}
- Hour {% include widgets/datetime.html replace=1 datetime=past_hour %}
- Day {% include widgets/datetime.html replace=1 datetime=past_day %}
- Week {% include widgets/datetime.html replace=1 datetime=past_week %}
- Month {% include widgets/datetime.html replace=1 datetime=past_month %}
- Year {% include widgets/datetime.html replace=1 datetime=past_year %}

## Apply if chidren/parent

Attribute `apply-if-children` in the form `class:children` will apply the `class` to the element if `children` is a descendant.

Attribute `apply-if-parent` in the form `class:parent` will apply the `class` to the element if `parent` is an ancestor.

- `class` is a space separated class list
- `children` and `parent` are selectors

**Examples**

```html
<!-- paragraph will have `hidden` class if has any parent with class `logged` -->
<p apply-if-parent="hidden:.logged">...</p>

<!-- table will have `no-border color-red` classes if has any children with class `past` -->
<table apply-if-children="no-border color-red:.past">...</table>
```