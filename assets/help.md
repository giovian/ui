---
title: Help
permalink: help/
order: 1000
---
{%- assign repo = site.github.public_repositories | where: "full_name", site.github.repository_nwo | first -%}
# Help
<div class="grid">
  <div markdown="1">
**Repository**
- [{{ site.github.repository_nwo }}]({{ site.github.repository_url }})
- Owner type `{{ repo.owner.type }}`
- Page type `{% if site.github.is_user_page %}User{% endif %}{% if site.github.is_project_page %}Project{% endif %}`
- Release `{{ site.github.releases | first | map: 'tag_name' | default: '-' }}` `{{ site.github.releases | first | map: 'name' | default: '-' }}`
- Created <code>{% include widgets/datetime.html datetime=repo.created_at replace=true %}</code>
- Modified <code>{% include widgets/datetime.html datetime=repo.modified_at replace=true %}</code>
- Site build <code>{% include widgets/datetime.html datetime=site.time replace=true %}</code>
{% assign html_pages = site.html_pages | sort: "order" %}
{% assign sorted_collections = site.collections | sort: "order" %}
**Pages order**
{% for item in html_pages %}- `{{ item.order | inspect }}` {{ item.title | default: item.name }}
{% endfor %}
**Collections order**
{% for item in sorted_collections %}- `{{ item.order | inspect }}` {{ item.title | default: item.label }} ({{ item.docs.size }} documents){% assign collection_docs = item.docs | sort: "order" %}{% for p in collection_docs %}
  - `{{ p.order | inspect }}` {{ p.title | default: p.path }}{% endfor %}
{% endfor %}
{% if site.remote_theme %}
**Remote theme**
- Repository [{{ site.remote_theme | split: '@' | first }}]({{ site.remote_theme | split: '@' | first | prepend: 'https://github.com/' }})
- Plugin [benbalter/jekyll-remote-theme](https://github.com/benbalter/jekyll-remote-theme) {{ site.github.versions["jekyll-remote-theme"] }}
- Hardcoded version `{%- capture version -%}{% include version.html %}{%- endcapture -%}{{ version | default: '-'}}`

**Latest remote theme release**
<ul github-api-url='repos/{{ site.remote_theme | split: '@' | first }}/releases/latest' github-api-out='tag_name,name,published_at'></ul>
{% endif %}
</div>
<div markdown="1">
**Auth**
<ul>
  <li><span apply-if-parent='hidden|html:not(.logged)'>Logged as <span apply-if-parent='hidden|html:not(.role-admin)'>admin</span><span apply-if-parent='hidden|html:not(.role-guest)'>guest</span></span><span apply-if-parent='hidden|.logged'>Not logged</span></li>
  {% include widgets/login.html %}
</ul>
<div apply-if-parent='hidden|html:not(.role-admin)' markdown="1">
**Builds**
<ul github-api-url-repo='pages/builds/latest' github-api-text='Latest' github-api-out='status, created_at'></ul>
<ul github-api-url-repo='pages/builds' github-api-method='POST' github-api-out='status' github-api-text='Request new build'></ul>
**Rate limit**
<ul github-api-url='rate_limit' github-api-text="Remaining and used" github-api-out='rate.used,rate.remaining,resources.search.used,resources.search.remaining'></ul>
**Local storage**
- [Log](#){:log-storage=''} in console
</div>
  </div>
</div>