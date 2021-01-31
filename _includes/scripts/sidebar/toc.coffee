if $('#markdown-toc').length is 1 and $('#sidebar-toc').length is 1
  # Move `toc` to sidebar
  $('#markdown-toc').detach().appendTo '#sidebar-toc'
else
  # Remove `<details id="sidebar-toc">` from the sidebar
  $('#sidebar-toc').remove()