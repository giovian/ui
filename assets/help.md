---
title: Help
permalink: help/
sidebar: []
order: 1000
---
{%- assign repo = site.github.public_repositories | where: "full_name", site.github.repository_nwo | first -%}
# Help
<div class="grid">
  <div markdown="1">
**Repository by Jekyll GitHub Metadata**
- <https://github.com/{{ site.github.repository_nwo }}>
- Owner type `{{ repo.owner.type }}`
- Page type `{% if site.github.is_user_page %}User{% endif %}{% if site.github.is_project_page %}Project{% endif %}`
- Release `{{ site.github.releases | first | map: 'tag_name' | default: '-' }}` `{{ site.github.releases | first | map: 'name' | default: '-' }}`
- Created <code>{% include widgets/datetime.html datetime=repo.created_at replace=true %}</code>
- Modified <code>{% include widgets/datetime.html datetime=repo.modified_at replace=true %}</code>
- Site build <code>{% include widgets/datetime.html datettime=site.time replace=true %}</code>
{% if site.remote_theme %}

**Remote by Jekyll GitHub Metadata**
- Theme <{{ site.remote_theme | split: '@' | first | prepend: 'https://github.com/' }}>
- Version `{% include version.html %}`
- Plugin <https://github.com/benbalter/jekyll-remote-theme> {{ site.github.versions["jekyll-remote-theme"] }}
{% endif %}

**Auth**
<ul>
  <li><span apply-if-parent='hidden|html:not(.logged)'>Logged as <span apply-if-parent='hidden|html:not(.role-admin)'>admin</span><span apply-if-parent='hidden|html:not(.role-guest)'>guest</span></span><span apply-if-parent='hidden|.logged'>Not logged</span></li>
  {% include widgets/login.html %}
</ul>
**Local storage**
- [Log](#){:log-storage=''} in console
</div>
  <div>
<div apply-if-parent='hidden|html:not(.role-admin)' markdown="1">
**Builds**
<ul github-api-url='repos/pages/builds/latest' github-api-text='Latest' github-api-out='status, created_at'></ul>
**Request a build**
<ul github-api-url='repos/pages/builds' github-api-method='POST' github-api-out='status'></ul>
</div>
  </div>
</div>