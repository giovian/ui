# Default attributes
inview_default = {{ site.inview | jsonify }} || {
  in:
    element: "h2"
    attribute: "id"
  out:
    element: "#markdown-toc a"
    attribute: "href"
  options: {}
}

# In view function
inview = (config = inview_default) ->
  if 'IntersectionObserver' of window
    callback = (entries) ->
      entries.forEach (entry) ->
        attribute = $(entry.target).attr config.in.attribute
        in_view = entry.isIntersecting
        ele = $("#{config.out.element}[#{config.out.attribute}*=#{attribute}]")
        if in_view then ele.addClass 'inview' else ele.removeClass 'inview'
        return # end entries loop
      return # end callback

    # start observing
    $(config.in.element).each ->
      new IntersectionObserver(callback, config.options).observe @

  return # end inview

# Initial call only if elements are presents
inview_init = (->
  if $(inview_default.in.element).length and $(inview_default.out.element).length
    inview())()

{%- capture api -%}
## In view

Observer for elements inside viewport.
```coffee
inview(config)
```

Will check if an `config.in.element` is inside the viewport and apply an `.inview`{:.language-sass} class to the `config.out.element` whom `config.out.attribute` contains `config.in.attribute`.

**Default `config` object**
```js
config = {
  in:
    element: "h2"
    attribute: "id"
  out:
    element: "#markdown-toc a"
    attribute: "href"
  options: {}
}
```
If a table of contents is present, when an `h2` title is inside the viewport, the corresponding TOC link will have an `.inview`{:.language-sass} class.

**Example `options` object (default `{}`)**
```yml
inview:
  options:
    rootMargin: "-100% 0% 0% 0%"
```
Configure in `_config.yml`
```yml
inview:
  in:
    element: 'h2'
    attribute: 'id'
  out:
    element: '#markdown-toc a'
    attribute: 'href'
  options:
    rootMargin: "-100% 0% 0% 0%"
```
{%- endcapture -%}