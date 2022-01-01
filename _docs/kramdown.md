---
order: 20
---

# Kramdown
{:.no_toc}
* toc
{:toc}

> <https://kramdown.gettalong.org/>

Kramdown is the default Markdown renderer for Jekyll and use the _GitHub Flavored Markdown (GFM) processor_.

Classes ids and attributes can be added with an Inline Attribute List (IAL)
```md
{: .class #id key="value"}
```
{:.minimal}

## Table of contents

Render an ordered or unordered nested list (with default ID `markdown-toc`) of the headers in the page.  

Add an IAL with reference name `toc` to a one element ordered or unordered list.
```md
* toc or 1. toc
{:toc}
```
{:.minimal}

Exclude headers from the TOC with the class `no_toc`.
```md
## Excluded header
{: .no_toc}
```
{:.minimal}

Check [toc widget]({{ 'docs/widgets#table-of-contents' | absolute_url }}) to put the TOC in the sidebar.

## Code

**Inline**

`` `<nav>`{:.language-html}`` render `<nav>`{:.language-html}

**Code blocks**

<div class="grid">
{%- assign code_files = 'fenced,liquid,kramdown,indented' | split: "," -%}
{% for code in code_files %}{% include code/{{ code }}.html %}{% endfor %}
</div>

To limit code block width to the content, use the `.minimal`{:.language-css} class appending `{: .minimal}` to the block.

## Tables

Use `|----` for a new `<tbody>`{:.language-html} and `|====` for a table footer `<tfoot>`{:.language-html}

| Header1 | Header2 | Header3 |
|:---|:---:|---:|
| cell1 | cell2 | cell3 |
| cell4 | cell5 | cell6 |
|----
| cell1 | cell2 | cell3 |
| cell4 | cell5 | cell6 |
|----
| cell1 | cell2 | cell3 |
| cell4 | cell5 | cell6 |
|====
| Foot1 | Foot2 | Foot3

Default TABLES have a border, rounded corners and shaded headers. A class color can be applied on rows or cells.

{% assign colors = "blue,green,red,orange,pink" | split: "," %}
<table>
  <thead>
    <tr>
      <th colspan=6>Colors</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>code</code></td>
      {% for color in colors %}
        <td class="color-{{ color }}">.color-{{ color }}</td>
      {% endfor %}
    </tr>
    {% for color in colors %}
      <tr class="color-{{ color }}">
        <td colspan=6>.color-{{ color }} <code>code</code></td>
      </tr>
    {% endfor %}
  </tbody>
  <tbody>
    <tr>
      <td colspan=6>New body</td>
    </tr>
  </tbody>
</table>

## Blockquotes

> Example

## Typography

|Kramdown|Result
|:---|:---
|`__` `**`|__Bold__
|`_` `*`|_Italic_

|HTML|Result
|:---|:---
|`del`|<del>Deleted</del>
|`ins`|<ins>Inserted</ins>
|`abbr[title]`|<abbr title="Abbreviation">Abbreviation</abbr>
|`cite`|<cite>Cite</cite>
|`kbd`|<kbd>Ctrl + S</kbd>
|`samp`|<samp>Sample</samp>
|`mark`|<mark>Highlighted</mark>
|`s`|<s>Strikethrough</s>
|`u`|<u>Underline</u>
|`small`|<small>small</small>
|`sub`|Text<sub>Sub</sub>
|`sup`|Text<sup>Sup</sup>

## Abbreviations

Abbreviated text is written normally and below the text add  
`*[normally]: Abbreviation`

*[normally]: Abbreviation

## Footnotes

Text is followed[^1] by `[^1]` and below the text add `[^1]: Footnote`.  
The note will be added at the end[^where] of the document.

```html
<sup id="fnref:1" role="doc-noteref">
  <a href="#fn:1" class="footnote" rel="footnote">1</a>
</sup>
```

```html
<div class="footnotes" role="doc-endnotes">
  <ol>
    <li id="fn:1" role="doc-endnote">
      <p>... <a href="#fnref:1" class="reversefootnote" role="doc-backlink">&#8617;</a></p>
    </li>
    ...
  </ol>
</div>
```

[^1]: Some *markdown* footnote definition
[^where]: End of page

## Definition lists

Elements: `<dl><dt><dd>`{:.language-html}  
Markdown: `: `&nbsp;for the descriptions  
- Empty line before new term
- End with a definition

```md
term
: definition
: another definition

another term
and another term
: and a definition for the term
```
term
: definition
: another definition

another term
and another term
: and a definition for the term