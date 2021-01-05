# Storage
storage =
  key: "{{ site.github.repository_nwo }}"
  get: (key) -> if key then storage.get_object()[key] else storage.get_object()
  get_object: () -> JSON.parse atob localStorage.getItem(storage.key) || "e30="
  set: (key, value) ->
    if key and value
      obj = storage.get_object()
      obj[key] = value
      storage.set_object obj
    return storage
  set_object: (obj) -> localStorage.setItem(storage.key, btoa JSON.stringify obj)
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