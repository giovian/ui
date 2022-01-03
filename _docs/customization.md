---
order: 10
---

# Customization
{:.no_toc}

* toc
{:toc}

{% include widgets/api.html include='page/favicon' %}

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

{% include widgets/api.html include='page/sidebar' %}
{% include widgets/api.html include='page/navigation' %}
{% include widgets/api.html include='page/footer' %}
{% include widgets/api.html include='page/init' %}

## Collections

Minimum configuration on `_config.yml` for pages in the folder `_myCollection`

```yml
collections:
  myCollection:
    output: true
    # title: Title

defaults:
  - scope:
      type: myCollection
    values:
      layout: default
```
{:.minimal}