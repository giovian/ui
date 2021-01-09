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

- Empty {% include widgets/datetime.html %}
- Embed {% include widgets/datetime.html embed=true %}
- Replace {% include widgets/datetime.html replace=true %}

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