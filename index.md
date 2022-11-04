---
---

# Home

**Initialize**

1. Fork
1. Settings > Pages `https://github.com/OWNER/REPO/settings/pages`
1. Source > `main` > Save

## Games

- open a pull
- merge pulls
  - check turn
  - generate

## To do

1. player join form refresh blank

- clipboard copy with a class
- `value` attribute on csv-table rows to style
- check multiple filters on csv-table headers
- double sidebar
- check daytime approximations
- use color classes for higlights
- use `oneOf` for changing keywords
- check `$id` schema absolute or relative

**Open pull**

```json
{
  "url": "https://api.github.com/repos/giovian/ui/pulls/2",
  "id": 1111067714,
  "number": 2,
  "state": "open",
  "locked": false,
  "title": "Create a pull request",
  "user": {
    "login": "trasparente",
    "id": 5657516,
    "node_id": "MDQ6VXNlcjU2NTc1MTY=",
    "type": "User",
    "site_admin": false
  },
  "body": "From riminino:main",
  "created_at": "2022-11-04T16:36:38Z",
  "updated_at": "2022-11-04T16:36:38Z",
  "head": {
    "label": "riminino:main",
    "ref": "main",
    "sha": "89600e3784f2d15d7756652ff269e428e5cf913d",
    "user": {
      "login": "riminino",
      "id": 16726337,
      "node_id": "MDEyOk9yZ2FuaXphdGlvbjE2NzI2MzM3",
      "avatar_url": "https://avatars.githubusercontent.com/u/16726337?v=4"
    },
  },
  "author_association": "MEMBER",
  "auto_merge": null,
  "active_lock_reason": null,
  "merged": false,
  "mergeable": null,
  "rebaseable": null,
  "mergeable_state": "unknown",
  "merged_by": null,
  "comments": 0,
  "review_comments": 0,
  "maintainer_can_modify": true,
  "commits": 33,
  "additions": 1,
  "deletions": 0,
  "changed_files": 1
}
```

**Process pulls**

```json
{
  "url": "https://api.github.com/repos/giovian/ui/pulls/2",
  "id": 1111067714,
  "node_id": "PR_kwDOE2AZXs5COYxC",
  "html_url": "https://github.com/giovian/ui/pull/2",
  "diff_url": "https://github.com/giovian/ui/pull/2.diff",
  "patch_url": "https://github.com/giovian/ui/pull/2.patch",
  "issue_url": "https://api.github.com/repos/giovian/ui/issues/2",
  "number": 2,
  "state": "open",
  "locked": false,
  "title": "Create a pull request",
  "user": {
    "login": "trasparente",
    "id": 5657516,
    "node_id": "MDQ6VXNlcjU2NTc1MTY=",
    "avatar_url": "https://avatars.githubusercontent.com/u/5657516?v=4",
    "gravatar_id": "",
    "url": "https://api.github.com/users/trasparente",
    "html_url": "https://github.com/trasparente",
    "followers_url": "https://api.github.com/users/trasparente/followers",
    "following_url": "https://api.github.com/users/trasparente/following{/other_user}",
    "gists_url": "https://api.github.com/users/trasparente/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/trasparente/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/trasparente/subscriptions",
    "organizations_url": "https://api.github.com/users/trasparente/orgs",
    "repos_url": "https://api.github.com/users/trasparente/repos",
    "events_url": "https://api.github.com/users/trasparente/events{/privacy}",
    "received_events_url": "https://api.github.com/users/trasparente/received_events",
    "type": "User",
    "site_admin": false
  },
  "body": "From riminino:main",
  "created_at": "2022-11-04T16:36:38Z",
  "updated_at": "2022-11-04T16:36:38Z",
  "closed_at": null,
  "merged_at": null,
  "merge_commit_sha": "6bedd9d635b116ce47d4adf653c7ab610e751c11",
  "assignee": null,
  "assignees": [],
  "requested_reviewers": [],
  "requested_teams": [],
  "labels": [],
  "milestone": null,
  "draft": false,
  "commits_url": "https://api.github.com/repos/giovian/ui/pulls/2/commits",
  "review_comments_url": "https://api.github.com/repos/giovian/ui/pulls/2/comments",
  "review_comment_url": "https://api.github.com/repos/giovian/ui/pulls/comments{/number}",
  "comments_url": "https://api.github.com/repos/giovian/ui/issues/2/comments",
  "statuses_url": "https://api.github.com/repos/giovian/ui/statuses/89600e3784f2d15d7756652ff269e428e5cf913d",
  "head": {
    "label": "riminino:main",
    "ref": "main",
    "sha": "89600e3784f2d15d7756652ff269e428e5cf913d",
    "user": {
      "login": "riminino",
      "id": 16726337,
      "node_id": "MDEyOk9yZ2FuaXphdGlvbjE2NzI2MzM3",
      "avatar_url": "https://avatars.githubusercontent.com/u/16726337?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/riminino",
      "html_url": "https://github.com/riminino",
      "followers_url": "https://api.github.com/users/riminino/followers",
      "following_url": "https://api.github.com/users/riminino/following{/other_user}",
      "gists_url": "https://api.github.com/users/riminino/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/riminino/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/riminino/subscriptions",
      "organizations_url": "https://api.github.com/users/riminino/orgs",
      "repos_url": "https://api.github.com/users/riminino/repos",
      "events_url": "https://api.github.com/users/riminino/events{/privacy}",
      "received_events_url": "https://api.github.com/users/riminino/received_events",
      "type": "Organization",
      "site_admin": false
    },
    "repo": {
      "id": 484458710,
      "node_id": "R_kgDOHOBA1g",
      "name": "ui",
      "full_name": "riminino/ui",
      "private": false,
      "owner": {
        "login": "riminino",
        "id": 16726337,
        "node_id": "MDEyOk9yZ2FuaXphdGlvbjE2NzI2MzM3",
        "avatar_url": "https://avatars.githubusercontent.com/u/16726337?v=4",
        "gravatar_id": "",
        "url": "https://api.github.com/users/riminino",
        "html_url": "https://github.com/riminino",
        "followers_url": "https://api.github.com/users/riminino/followers",
        "following_url": "https://api.github.com/users/riminino/following{/other_user}",
        "gists_url": "https://api.github.com/users/riminino/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/riminino/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/riminino/subscriptions",
        "organizations_url": "https://api.github.com/users/riminino/orgs",
        "repos_url": "https://api.github.com/users/riminino/repos",
        "events_url": "https://api.github.com/users/riminino/events{/privacy}",
        "received_events_url": "https://api.github.com/users/riminino/received_events",
        "type": "Organization",
        "site_admin": false
      },
      "html_url": "https://github.com/riminino/ui",
      "description": "Giovian user interface",
      "fork": true,
      "created_at": "2022-04-22T14:13:29Z",
      "updated_at": "2022-11-04T15:38:09Z",
      "pushed_at": "2022-11-04T16:35:56Z",
      "git_url": "git://github.com/riminino/ui.git",
      "ssh_url": "git@github.com:riminino/ui.git",
      "clone_url": "https://github.com/riminino/ui.git",
      "svn_url": "https://github.com/riminino/ui",
      "homepage": "https://riminino.github.io/ui/",
      "size": 760,
      "stargazers_count": 0,
      "watchers_count": 0,
      "language": "CoffeeScript",
      "has_issues": false,
      "has_projects": true,
      "has_downloads": true,
      "has_wiki": true,
      "has_pages": true,
      "forks_count": 0,
      "mirror_url": null,
      "archived": false,
      "disabled": false,
      "open_issues_count": 0,
      "license": null,
      "allow_forking": true,
      "is_template": false,
      "web_commit_signoff_required": false,
      "topics": [],
      "visibility": "public",
      "forks": 0,
      "open_issues": 0,
      "watchers": 0,
      "default_branch": "main"
    }
  },
  "base": {
    "label": "giovian:main",
    "ref": "main",
    "sha": "c4bad93038c7514ff14957e1e8b29faf3afb0f4d",
    "user": {
      "login": "giovian",
      "id": 76629988,
      "node_id": "MDEyOk9yZ2FuaXphdGlvbjc2NjI5OTg4",
      "avatar_url": "https://avatars.githubusercontent.com/u/76629988?v=4",
      "gravatar_id": "",
      "type": "Organization",
      "site_admin": false
    },
    "repo": {
      "id": 325065054,
      "node_id": "MDEwOlJlcG9zaXRvcnkzMjUwNjUwNTQ=",
      "name": "ui",
      "full_name": "giovian/ui",
      "private": false,
      "owner": {
        "login": "giovian",
        "id": 76629988,
        "node_id": "MDEyOk9yZ2FuaXphdGlvbjc2NjI5OTg4",
        "type": "Organization",
        "site_admin": false
      },
      "html_url": "https://github.com/giovian/ui",
      "description": "Giovian user interface",
      "fork": false,
      "created_at": "2020-12-28T16:47:01Z",
      "updated_at": "2022-10-25T20:07:52Z",
      "pushed_at": "2022-11-04T16:36:38Z",
      "git_url": "git://github.com/giovian/ui.git",
      "ssh_url": "git@github.com:giovian/ui.git",
      "clone_url": "https://github.com/giovian/ui.git",
      "svn_url": "https://github.com/giovian/ui",
      "homepage": "https://giovian.github.io/ui/",
      "size": 736,
      "stargazers_count": 0,
      "watchers_count": 0,
      "language": "CoffeeScript",
      "has_issues": true,
      "has_projects": true,
      "has_downloads": true,
      "has_wiki": true,
      "has_pages": true,
      "forks_count": 1,
      "mirror_url": null,
      "archived": false,
      "disabled": false,
      "open_issues_count": 1,
      "license": null,
      "allow_forking": true,
      "is_template": false,
      "web_commit_signoff_required": false,
      "topics": [],
      "visibility": "public",
      "forks": 1,
      "open_issues": 1,
      "watchers": 0,
      "default_branch": "main"
    }
  },
  "author_association": "MEMBER",
  "auto_merge": null,
  "active_lock_reason": null
}
```