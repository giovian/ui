---
---

# Customization

- **FAVICON** `/assets/images/favicon.ico`
- **SASS** `/assets/css/stylesheet.sass`

```sass
---
---
// Override default variabiles here
@import ui
// Override CSS rules here
```

## Footer

The `footer` include 3 files:
- `_includes/footer/left.html` GitHub links
- `_includes/footer/center.html` empty by default
- `_includes/footer/right.html` Top link and mode toggle link

To override these defaults add any of theese files to your repository with customized content.

## Colors

<details open>
  <summary>Blockquotes</summary>
<blockquote>
  <h3>Plain</h3>
  <p markdown=1>Lorem ipsum dolor [sit amet](), consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
  <p class="fg-secondary" markdown=1>`.fg-secondary` Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
  <div class="bg-secondary minimum-padding">Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
  </div>
</blockquote>
{%- assign colors = 'blue,green,orange,red' | split: ',' -%}
{% for c in colors %}
<blockquote class="color-{{ c }}">
  <h3>.color-{{ c }}</h3>
  <p markdown=1>Lorem ipsum dolor [sit amet](), consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
  <p class="fg-secondary" markdown=1>`.fg-secondary` Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
  <div class="bg-secondary minimum-padding">Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
  </div>
</blockquote>
{% endfor %}
<blockquote class="mode-opposite color-red">
  <h3>blockquote opposite</h3>
  <p markdown=1>Lorem ipsum dolor [sit amet](), consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
  <p class="fg-secondary" markdown=1>`.fg-secondary` Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
  <div class="bg-secondary minimum-padding">Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
  </div>
</blockquote>
</details>

### Tables

<table>
  <thead>
    <tr>
      <th colspan=5>Colors</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>code</code></td>
      {% for c in colors %}
        <td class="color-{{ c }}">.color-{{ c }}</td>
      {% endfor %}
    </tr>
    {% for c in colors %}
      <tr class="color-{{ c }}">
        <td colspan=5>.color-{{ c }} <code>code</code></td>
      </tr>
    {% endfor %}
  </tbody>
</table>
<table>
  <thead>
    <tr>
      <th colspan=5 class="mode-opposite">Colors</th>
    </tr>
  </thead>
  <tbody>
    <tr class="mode-opposite">
      <td><code>code</code></td>
      {% for c in colors %}
        <td class="color-{{ c }}">.color-{{ c }}</td>
      {% endfor %}
    </tr>
    {% for c in colors %}
      <tr class="mode-opposite color-{{ c }}">
        <td colspan=5>.color-{{ c }} <code>code</code></td>
      </tr>
    {% endfor %}
  </tbody>
</table>