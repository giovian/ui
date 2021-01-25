---
order: 3
search:
  title: Search
  url: https://api.github.com/search/code
  headers:
    Accept: application/vnd.github.v3.text-match+json
  data:
    q: remote_theme giovian ui filename:_config
  out: [total_count, incomplete_results]
  loop:
    property: items
    out: [repository full_name, repository description, path]
    loop:
      property: text_matches
      out: [fragment]
      loop:
        property: matches
        out: [text]
repo:
  description: Get repository
  url: https://api.github.com/repos/giovian/ui
  out: [id, owner id]
commits:
  url: https://api.github.com/repos/giovian/ui/commits
  data:
    per_page: 3
  loop:
    out: [commit message, commit author date]
    loop:
      property: parents
      out: [sha]
spx:
  title: SpaceX-API
  description: Next launch
  url: https://api.spacexdata.com/v4/launches/next
  out: [flight_number, name, date_unix, static_fire_date_unix]
  loop:
    property: cores
    out: [flight, landing_type]
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

## API

A YAML object will execute an API call.

| Property | Type | Default | Description
|---|---|:---:|---
| `title` | string | `API` | API title
| `description` | string | | API description
| `url` | url | | URL of the API
| `headers` | object | `{}` | Headers parameters
| `data` | object | `{}` | Data payload
| `out` | array | | Array of response properties to show
| `loop` | object | | Used to loop API response
| `property` | string | | Response property name to loop on

{% include widgets/api.html api=page.search %}
{% include widgets/api.html api=page.commits %}
{% include widgets/api.html api=page.repo %}
{% include widgets/api.html api=page.spx %}