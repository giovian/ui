# STORAGE
# localStorage key is "owner/repository"
# GET ---------------------------
# storage.get()                     Return whole object { ... }
# storage.get('key')                Return value (can be number, string, array, object)
# storage.get('object')['property'] Return object's property
# storage.get('array')[index]       Return index element of array
# SET ---------------------------> Return storage
# storage.set('key', value)         Store { key: value }
# PUSH --------------------------> Return storage
# storage.push('array', element)    Push element to array
# CONCAT ------------------------> Return storage
# storage.concat('array', [array])  Store array's merge
# ASSIGN ------------------------> Return storage
# storage.assign('object', object)  Store merged objects
# CLEAR -------------------------
# storage.clear()                   Return storage, remove localStorage key
# storage.clear('key')              Return storage, remove { key: value, ... }
storage =
  key: "{{ site.github.repository_nwo }}"
  get: (key) -> if key then storage.get_object()[key] else storage.get_object()
  get_object: () -> JSON.parse atob localStorage.getItem(storage.key) || "e30="
  set_object: (obj) -> localStorage.setItem(storage.key, btoa JSON.stringify obj)
  push: (key, element) -> storage.set key, (storage.get(key) || []).concat [element]
  concat: (key, array) -> storage.set key, (storage.get(key) || []).concat array
  assign: (key, object) -> storage.set key, Object.assign(storage.get(key) || {}, object)
  set: (key, value) ->
    if key and value
      obj = storage.get_object()
      obj[key] = value
      storage.set_object obj
    return storage
  clear: (key) ->
    if key
      obj = storage.get_object()
      delete obj[key]
      storage.set_object obj
    else
      localStorage.removeItem(storage.key)
    return storage

console.group storage.key
console.log localStorage.getItem storage.key
console.log storage.get()
console.groupEnd()