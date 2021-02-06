---
stone:
  title: Stones
  file: "stones"
  url: https://necrologie.messaggeroveneto.gelocal.it/
  get: ".item .died .picture a img"
  attribute: "alt"
  update: ".gnn-header_uptime"
paper:
  title: Papers
  url: https://www.goodreads.com/book/show/56078386-heaven-s-river
---

# Home

This is <span class="fg-secondary">secondary</span>.

{% include widgets/parse.html parse=page.stone %}

{% include widgets/parse.html parse=page.paper %}