---
order: 10
---

# Customization
{:.no_toc}

* toc
{:toc}

## Theme

The style {% include widgets/github_link.html path='_sass/default/_variabiles.sass' text='variabiles' remote=true %} can be overridden creating the file `_sass/variabiles.sass`.  
Custom sass can be added creating the file `_sass/custom.sass`.  
Theme can be set in the `_config.yml` file with the `css.theme` value, default to `default`.

```yml
#_config.yml
css:
  theme: default
```
{:.minimal}

To create a new theme, add a file `_sass/theme-name.sass`.

## Colors

Color variations and link colors are defined in the theme file for `dark` and `light` modes.
```sass
//
// LIGHT MODE
// --------------------------------------
// Colors
$blue-light:     MediumBlue !default
$red-light:      FireBrick !default
$green-light:    DarkGreen !default
$orange-light:   OrangeRed !default
$pink-light:     Fuchsia !default
// Links
$link-light:     $blue-light !default
// As a list
$colors-light: (blue: $blue-light, red: $red-light, green: $green-light, orange: $orange-light, pink: $pink-light) !default
```
For every colors there are five shades defined in the lightness SASS list for background `bg`, foreground `fg`, secondary background `bg-secondary` and foreground `fg-secondary`, and borders `border`.
```sass
// Colors shades
$color-lightness-light: (bg: 94%, fg: 17%, bg_secondary: 91%, fg_secondary: 50%, border: 79%) !default
```

Colors are applied to elements with the classes `.blue .red .green .orange .pink`{:.language-css}.
<div class="grid">
  {%- assign colors = "default,secondary,blue,green,red,orange,pink" | split: "," -%}
  {% for color in colors %}
    <div class="p-around rounded {{ color }}">
    Example <i>{{ color }}</i>: <span class="fg-secondary">secondary text</span>
    <div class="p-around mvh bg-secondary rounded">Secondary background</div>
    and <a href="#">Link</a>
    </div>
  {% endfor %}
</div>

## Buttons

<div class="flex" style="gap: .2em;">
{% for color in colors %}
<button type="button" name="button" class="{{ color }}">{{ color | capitalize }}</button>
{% endfor %}
</div>

## Syntax highlight

Syntax highlight colors for dark and light color scheme are in {% include widgets/github_link.html path='_sass/default/syntax' remote=true %}.

<pre class="highlight">
<span class="na">.na</span> <span class="nv">.nv</span> <span class="s">.s</span> <span class="nx">.nx</span> <span class="nb">.nb</span> <span class="o">.o</span> <span class="pi">.pi</span> <span class="kr">.kr</span> <span class="no">.no</span> <span class="nt">.nt</span> <span class="m">.m</span> <span class="c">.c</span> <span class="p">.p</span>
</pre>

{% include widgets/api.html include='page/sidebar' %}
{% include widgets/api.html include='page/nav' %}
{% include widgets/api.html include='page/navigation' %}
{% include widgets/api.html include='page/footer' %}

## Language

Set the page language and dates format (default to `en-US`).

```yml
#_config.yml
language: 'en-US'
```
{:.minimal}

{% include widgets/api.html include='page/init' %}

## Collections

Minimum configuration on `_config.yml` for pages in the folder `_myCollection`

```yml
collections:
  myCollection:
    output: true
    # title: My Collection
    # order: 10
    # sort_by: order

defaults:
  - scope:
      type: myCollection
    values:
      layout: default
```
{:.minimal}

{% include widgets/api.html include='page/favicon' %}

## Defaults

```yml
# _config.yml

# Favicon
favicon:
  ico: '/favicon.ico'
  png: '/favicon.png'

# Language
language: 'en-US'

# SASS Theme
css:
  theme: default

# Dark / Light mode
mode: dark

# Visibility header, navigation bar and footer
header: false
nav: false
footer: false

# Include page metadata at top page
metadata: false

# Include pagination at bottom page
pagination: false

# Sort pages
sort_by: 'date'

# Widgets in _includes/page/navigation for the top navigation bar
navigation: [pages, collections, login]

# Widgets in _includes/widgets for the sidebar
sidebar: [navigation, toc, meta]

# Add a collection
collections:
  myCollection:
    output: true
    title: My Collection
    order: 10

defaults:
  - scope:
      type: myCollection
    values:
      layout: default
```