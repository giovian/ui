reduce_object = (key, obj) -> key.split('.').reduce(
  ((acc, part) => acc && acc[part]), obj
)
storage =
  # Shorcuts
  key: '{{ site.github.repository_nwo }}'
  get: (key) ->
    return if key then reduce_object key, storage.get_object() else storage.get_object()
  get_object: ->
    try JSON.parse(Base64.decode(localStorage.getItem(storage.key))) catch e then {}
  set_object: (obj) ->
    localStorage.setItem(storage.key, Base64.encode JSON.stringify obj)
  push: (key, element) -> storage.set key, (storage.get(key) || []).concat [element]
  concat: (key, array) -> storage.set key, (storage.get(key) || []).concat array
  assign: (key, object) -> storage.set key, Object.assign(storage.get(key) || {}, object)
  set: (key, value) ->
    if key
      if value and !jQuery.isEmptyObject value
        obj = storage.get_object()
        obj[key] = value
        storage.set_object obj
      else storage.clear key
    return storage
  clear: (key) ->
    if key
      obj = storage.get_object()
      delete obj[key]
      storage.set_object obj
    else
      localStorage.removeItem(storage.key)
    return storage
  console: ->
    console.group storage.key
    console.log localStorage.getItem storage.key
    console.log storage.get()
    console.groupEnd()
    return

# Link to log storage in the console
$(document).on "click", "a[log-storage]", (e) ->
  e.preventDefault()
  storage.console()

{%- capture api -%}
## Storage

Hashed localStorage object with key `owner/repository`.

If unlogged is empty `null`

If logged:
```json
{
  details: {
    "page-title-1|detail-summary-1": false,
    "page-title-2|detail-summary-2": true
  },
  login: {
    token: "...",
    user: "username",
    logged: "2021-08-18T16:06:38.559Z",
    role: "admin"/"guest"
  },
  repository: {
    fork: true/false,
    parent: false/repository_object
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