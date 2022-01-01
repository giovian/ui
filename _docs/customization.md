---
order: 10
---

# Customization
{:.no_toc}

* toc
{:toc}

## Favicon

The favicon files are expected to be `/favicon.ico` and `/favicon.png`.

Specify different paths in `_config.yml`
```yml
favicon:
  ico: "ico-file-path"
  png: "png-file-path"
```

Changing favicon files require updating the browser cache opening the file directly: [ico file]({{ 'favicon.ico' | absolute_url }}), [png file]({{ 'favicon.png' | absolute_url }}).

## Theme

The theme is set in the `_config.yml` file with the value `css.theme`, default to `dark`.

```yml
# _config.yml
css:
  theme: light
```

Theme list: `dark`, `light`

## Sass

The theme {% include widgets/github_link.html path='_sass/default/_variabiles.sass' text='variabiles' %} can be overridden in the (empty) file `_sass/variabiles.sass`.  

Custom sass can be included in the (empty) file `_sass/custom.sass`.

To create a new theme, add a file `_sass/theme-name.sass`. To change only the color scheme, include in the file the colors and lightness variabiles and `@import default`{:.language-sass}.

## Colors

Color variations are defined in the theme file, along with the link color.
```sass
$link-color: DodgerBlue
$colors: (blue: DodgerBlue, red: Red, green: LimeGreen, orange: Orange, pink: Fuchsia)
```
For every colors there are five shades defined in the lightness SASS list for background, foreground, secondary background and foreground and borders.
```sass
$lightness: (bg: 4%, fg: 83%, bg_secondary: 9%, fg_secondary: 57%, border: 21%)
```

Colors are applied to elements with the classes `.color-(blue/red/green/orange/pink)`.
<div class="grid">
{%- assign colors = "blue,green,red,orange,pink,default" | split: "," -%}
{% for color in colors %}
<div class="p-around rounded color-{{ color }}">
Example {{ color }} <span class="fg-secondary">secondary text</span>
<div class="p-around mvh bg-secondary rounded">Secondary background</div>
and <a href="#">Link</a>
</div>
{% endfor %}
</div>

## Syntax highlight

Syntax highlight theme is set in the `_config.yml` file with the value `css.syntax`, default to `rouge/molokai_custom`.

```yml
# _config.yml
css:
  syntax: rouge/github
```

Possible themes are in {% include widgets/github_link.html path='_sass/syntax' %}. 

## Sidebar

The main page content use `flexbox` to show an optional sidebar.

```html
<main>
  <div class="wrapper">
    <aside><!-- Sidebar --></aside>
    <section><!-- Page content --></section>
  </div>
</main>
```

The sidebar will be populated with widgets included from the folder `_includes/widgets/`.

Select the widgets with a YAML array `sidebar: [...]`{:.language-yml}:

<div class="grid">
<div markdown="1">
For every page

```yml
# _config.yml
defaults:
  - scope:
      path: ""
    values:
      sidebar: [...]
```
</div>
<div markdown="1">
For pages in collections

```yml
# _config.yml
defaults:
  - scope:
      type: my-collection
    values:
      sidebar: [...]
```
</div>
</div>

For singular pages, in the _front-matter_

```yml
---
sidebar: [...]
---
```

To add custom content, create a `_includes/widgets/sidebar.html` file and include it in the array: `sidebar: [sidebar]`{:.language-yml}

To choose sidebar side add `$sidebar-side: left/right`{:.language-sass} in the {% include widgets/github_link.html path='_sass/variabiles.sass' %} file (default is `right`).

The default sidebar width is `0.3` times the main content, customize with `$sidebar-width`{:.language-sass}.

If the sidebar is empty (no widgets) it will collapse.

{% include widgets/api.html include='page/navigation' %}
{% include widgets/api.html include='page/footer' %}

## Collections

Minimum configuration on `_config.yml` for pages in the folder `_myCollection`

```yml
collections:
  myCollection:
    output: true

defaults:
  - scope:
      type: myCollection
    values:
      layout: default
```