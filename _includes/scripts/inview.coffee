config_default = {
  in:
    element: 'h2'
    attribute: 'id'
  out:
    element: '#markdown-toc a'
    attribute: 'href'
}
inview = (configuration = {}, options = {}) ->
  config = $.extend {}, config_default, configuration
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
    $(config.in.element).each -> new IntersectionObserver(callback, options).observe @

  return # end inview

{%- capture api -%}
## In view

Observer for elements inside viewport.
```coffee
inview(config, options)
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
}
```
If a table of contents is present, when an `h2` title is inside the viewport, the corresponding TOC link will have an `.inview`{:.language-sass} class.

**Example `options` object (default `{}`)**
```js
options = {
  root: document
  rootMargin: "0px"
  threshold: 0
}
```
{%- endcapture -%}