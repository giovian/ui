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

## Colors

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

## Mode opposite

<blockquote class="mode-opposite">
  <h3>blockquote opposite</h3>
  <p markdown=1>Lorem ipsum dolor [sit amet](), consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
  <p class="fg-secondary" markdown=1>`.fg-secondary` Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
  <div class="bg-secondary minimum-padding">Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
  </div>
</blockquote>

Table opposite | Table
---|---
14 | `Unico`
{:.mode-opposite}


<table>
  <thead>
    <tr>
      <th>Prova</th>
      <th>Table</th>
    </tr>
  </thead>
  <tbody>
    <tr class="mode-opposite">
      <td>Row opposite</td>
      <td><code class="language-plaintext highlighter-rouge">Unico</code></td>
    </tr>
    <tr>
      <td class="mode-opposite">Cell opposite</td>
      <td><code class="language-plaintext highlighter-rouge">Unico</code></td>
    </tr>
  </tbody>
</table>