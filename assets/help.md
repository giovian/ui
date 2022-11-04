---
title: Help
permalink: help/
order: 1000
---
{% include page/init.html %}
{%- assign repo = site.github.public_repositories | where: "full_name", site.github.repository_nwo | first -%}
# Help
<div class="grid">
  <div markdown="1">
<details markdown=1>
<summary markdown=1>
  **Repository**
</summary>
- [{{ site.github.repository_nwo }}]({{ site.github.repository_url }})
- Owner type `{{ repo.owner.type }}`
- Owner name `{{ site.github.owner_name }}`
- Page type `{% if site.github.is_user_page %}User{% endif %}{% if site.github.is_project_page %}Project{% endif %}`
- Fork `{{ repo.fork | inspect }}`
- Release `{{ site.github.releases | first | map: 'tag_name' | default: '-' }}` `{{ site.github.releases | first | map: 'name' | default: '-' }}`
- Created <code>{% include widgets/datetime.html datetime=repo.created_at replace=true %}</code>
- Modified <code>{% include widgets/datetime.html datetime=repo.modified_at replace=true %}</code>
- Site build <code>{% include widgets/datetime.html datetime=site.time replace=true %}</code>
</details>
{%- capture def -%}<i class="fg-secondary">default</i>{%- endcapture -%}
{% assign html_pages = site.html_pages | sort: sort_by %}
{% assign sorted_collections = site.collections | sort: sort_by %}
<details markdown=1>
<summary markdown=1>
  **Layout**
</summary>
- mode `{{ mode }}` {% if mode == default_mode %}{{ def }}{% endif %}
- nav `{{ nav | inspect }}` {% if nav == default_nav %}{{ def }}{% endif %}
- header `{{ header | inspect }}` {% if header == default_header %}{{ def }}{% endif %}
- navigation {% if navigation == default_navigation %}{{ def }}
  {% endif %}{%- if navigation.size == 0 -%}`[]`{%- else -%}  
  {% for n in navigation %}- `{{ n | strip }}`
  {% endfor %}{% endif %}
- sidebar {% if sidebar == default_sidebar %}{{ def }}
  {% endif %}{%- if sidebar.size == 0 -%}`[]`{%- else -%}  
  {% for s in sidebar %}- `{{ s | strip }}`
  {% endfor %}{% endif %}
- footer `{{ footer | inspect }}` {% if footer == default_footer %}{{ def }}{% endif %}
- metadata `{{ metadata | inspect }}` {% if metadata == default_metadata %}{{ def }}{% endif %}
- pagination `{{ pagination | inspect }}` {% if pagination == default_pagination %}{{ def }}{% endif %}
- sort_by `{{ sort_by }}` {% if sort_by == default_sort_by %}{{ def }}{% endif %}
- prefers-color-scheme <code class="bg-secondary"><span class="prefers-color-scheme"></span></code>
</details>

<details markdown=1>
<summary markdown=1>
  **Pages {{ sort_by }} value**
</summary>
{% assign html_sorted = html_pages | sort: sort_by %}{% for item in html_sorted %}- `{{ item[sort_by] | inspect }}` {{ item.title | default: item.name }}
{% endfor %}
</details>

<details markdown=1>
<summary markdown=1>
  **Collections and pages {{ sort_by }}**
</summary>
{% for collection in sorted_collections %}- `{{ collection.order | inspect }}` {{ collection.title | default: collection.label }} ({{ collection.docs.size }} documents){% assign collection_docs = collection.docs | sort: sort_by %}{% for p in collection_docs %}
  - `{{ p[sort_by] | inspect }}` {{ p.title | default: p.path }}{% endfor %}
{% endfor %}
</details>

{% if site.remote_theme %}
<details markdown=1>
<summary markdown=1>
  **Remote theme**
</summary>
- Repository [{{ site.remote_theme | split: '@' | first }}]({{ site.remote_theme | split: '@' | first }})
- Branch `{{ site.remote_theme | split: '@' | last | default: '-' }}`
- Plugin [jekyll-remote-theme](https://github.com/benbalter/jekyll-remote-theme) {{ site.github.versions["jekyll-remote-theme"] }}
</details>

<details markdown=1>
<summary markdown=1>
  **Latest remote theme release**
</summary>
<ul github-api-url='repos/{{ site.remote_theme | split: '@' | first }}/releases/latest' github-api-out='tag_name,name,published_at'></ul>
</details>
{% endif %}

</div>
<div markdown="1">
**Auth**
<ul>
  <li><span class='logged'>Logged as <span class='role-admin'>admin</span><span class='role-guest'>guest</span></span><span class='unlogged'>Not logged</span></li>
  {% include widgets/login.html %}
</ul>
<div class='role-admin' markdown="1">
**Builds**
<ul github-api-url-repo='pages/builds/latest' github-api-text='Latest' github-api-out='status, created_at'></ul>
<ul github-api-url-repo='pages/builds' github-api-method='POST' github-api-out='status' github-api-text='Request new build'></ul>
**Repositories using giovian/ui**
<ul github-api-url='search/code?q=giovian/ui+in:file+language:yml+filename:_config+path:/' github-api-out='total_count,items[repository.html_url]' github-api-text='Search'></ul>
**Forks**
<ul github-api-url-repo='forks' github-api-out='html_url' github-api-text='Forks'></ul>
**Rate limit**
<ul github-api-url='rate_limit' github-api-text="Remaining and used" github-api-out='rate.used,rate.remaining,resources.search.used,resources.search.remaining'></ul>
</div>
**Local storage**
- [Log](#){:log-storage=''} in console
</div>
</div>