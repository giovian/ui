# Reduce object from key notation helper
reduce_object = (key, obj) -> key.split('.').reduce ((acc, part) => acc && acc[part]), obj

# Storage object
storage =
  # Shorcuts
  key: '{{ site.github.repository_nwo }}'
  get: (key) ->
    return if key then reduce_object key, storage.check_object() else storage.check_object()
  check_object: ->
    obj = storage.get_object()
    return if Object.keys(obj).length then obj else {}
  get_object: ->
    try JSON.parse(Base64.decode(localStorage.getItem(storage.key))) catch e then {}
  set_object: (obj) ->
    localStorage.setItem(storage.key, Base64.encode JSON.stringify obj)
  push: (key, element) -> storage.set key, (storage.get(key) || []).concat [element]
  concat: (key, array) -> storage.set key, (storage.get(key) || []).concat array
  assign: (key, object) ->
    storage.set key, $.extend(true, storage.get(key) || {}, object)
  set: (key, value) ->
    if key
      if value isnt undefined and value isnt {}
        obj = storage.check_object()
        obj[key] = value
        storage.set_object obj
      else storage.clear key
    return storage
  clear: (key) ->
    if key
      obj = storage.check_object()
      delete obj[key]
      keys = key.split '.'
      keys.reduce ((acc, part, index) ->
        if index is keys.length-1 then delete acc?[part]
        if !Object.keys(acc || {}).length then delete obj[keys[index-1]]
        return acc?[part]
      ), obj
      storage.set_object obj
    else
      localStorage.removeItem storage.key
    return storage
  console: ->
    console.group storage.key
    console.log localStorage.getItem storage.key
    console.log storage.get()
    console.groupEnd()
    return storage

# Link to log storage in the console
$(document).on 'click', 'a[log-storage]', (e) ->
  e.preventDefault()
  storage.console()

{%- capture api -%}
## Storage

Hashed localStorage object with key `owner/repository`.

```js
{
  'details': {
    'page-title|detail-summary': false
  },
  'sort': {
    'page-title|form-index': 'down'
  },
  'flippers': {
    'page-title|flipper-container-index': [tab-link-index]
  },
  'github_api': {
    'api_request_url': {
      'etag': string,
      'ifModified': date-string,
      'data': object or array
    }
  },
  'rate_limit': number,
  'login': {
    'token': '...',
    'user': 'username',
    'logged': '2021-08-18T16:06:38.559Z',
    'role': 'admin'/'guest'
  },
  'repository': {
    'fork': true/false,
    'parent': false/{repository object}
  }
}
```

**GET**

```coffee
# Return whole object { ... }
storage.get()
# Return value (can be number, string, array, object), key is a dot notation
storage.get("key")
storage.get("key.nested.property")
# Return object's property
storage.get("object")["property"]
# Return index element of array
storage.get("array")[index]
```
**SET**
```coffee
# Store { key: value } (can be number, string, array, object)
storage.set("key", value)
```
**PUSH**
```coffee
# Push element to array
storage.push("array", element)
```
**CONCAT**
```coffee
# Store array's merge
storage.concat("array", [array])
```
**ASSIGN**
```coffee
# Store merged objects
storage.assign("object", object)
```
**CLEAR**
```coffee
# Return storage, remove localStorage key
storage.clear()
# Return storage, remove { key: value, ... }
storage.clear("key")
```
**CONSOLE**
```coffee
# Show storage objects in console
storage.console()
```
{%- endcapture -%}