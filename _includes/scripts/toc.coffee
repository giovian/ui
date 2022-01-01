if $('#markdown-toc').length is 1 and $('#widget-toc').length is 1
  # Move `toc` to sidebar
  $('#markdown-toc').detach().appendTo '#widget-toc'
else
  # Remove `<details id="widget-toc">` from the page
  $('#widget-toc').remove()
{%- capture api -%}
## Table of contents

Will move the [markdown table of contents]({{ 'docs/kramdown/#table-of-contents' | absolute_url }}) inside the [toc widget]({{ 'docs/widgets/#table-of-contents' | absolute_url }}).  
If the markdown toc is not present, will remove the widget.
{%- endcapture -%}
