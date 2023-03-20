extends Node

#Stores dictionaries like watch_call_on_set_meta = {nameString = callable, ...} in object metadata
#Use set_object_prop(obj, prop, ...) instead of obj.prop = ... to trigger other object's callables watching that prop
#Use call_on_set(obj, prop, fn) to call fn when obj.prop changes

func add_callable_to_dict(dict: Dictionary, key: String, value: Callable) -> bool:
  var existing_callable_array = dict.get(key)
  if existing_callable_array:
    if existing_callable_array.has(value):
      return false
    else:
      existing_callable_array.push_back(value)
      return true
  else:
    var new_callable_array = [value]
    dict[key] = new_callable_array
    return true

func remove_callable_from_dict(dict: Dictionary, key: String, value: Callable) -> bool:
  var existing_callable_array: Array = dict.get(key)
  if existing_callable_array:
    existing_callable_array.erase(value)
    return true
  else:
    return false

func call_callable(dict: Dictionary, signalers_name: String, args: Array):
  var callable_array = dict.get(signalers_name)
  if callable_array == null:
    return
  for callable in callable_array:
    callable.callv(args)


func call_on_set_meta(obj: Object, key: String, fn: Callable):
  var callable_array
  if not obj.has_meta('watch_call_on_set_meta'):
    obj.set_meta('watch_call_on_set_meta', {})
    callable_array = obj.get_meta('watch_call_on_set_meta')
  else:
    callable_array = obj.get_meta('watch_call_on_set_meta')
  add_callable_to_dict(callable_array, key, fn)
  
func stop_calling_on_set_meta(obj: Object, key: String, fn: Callable):
  if not obj.has_meta('watch_call_on_set_meta'):
    return
  var callable_array = obj.get_meta('watch_call_on_set_meta')
  remove_callable_from_dict(callable_array, key, fn)
  
func set_object_meta(obj: Object, key: String, value: Variant):
  obj.set_meta(key, value)
  if not obj.has_meta('watch_call_on_set_meta'):
    return
  var callable_array = obj.get_meta('watch_call_on_set_meta')
  call_callable(callable_array, key, [])


func call_on_set_prop(obj: Object, prop: String, fn: Callable):
  var callable_array
  if not obj.has_meta('watch_call_on_set_prop'):
    callable_array = {}
    obj.set_meta('watch_call_on_set_prop', callable_array)
  else:
    callable_array = obj.get_meta('watch_call_on_set_prop')
  add_callable_to_dict(callable_array, prop, fn)
  
func stop_calling_on_set_prop(obj: Object, prop: String, fn: Callable):
  if not obj.has_meta('watch_call_on_set_prop'):
    return
  var callable_array = obj.get_meta('watch_call_on_set_prop')
  remove_callable_from_dict(callable_array, prop, fn)
  
func set_object_prop(obj: Object, prop: String, value: Variant):
  obj.set(prop, value)
  if not obj.has_meta('watch_call_on_set_prop'):
    return
  var callable_array = obj.get_meta('watch_call_on_set_prop')
  call_callable(callable_array, prop, [])



func call_on_notify(obj: Object, notename: String, fn: Callable):
  var callable_array
  if not obj.has_meta('watch_call_on_notify'):
    callable_array = {}
    obj.set_meta('watch_call_on_notify', callable_array)
  else:
    callable_array = obj.get_meta('watch_call_on_notify')
  add_callable_to_dict(callable_array, notename, fn)
  
func stop_calling_on_notify(obj: Object, notename: String, fn: Callable):
  if not obj.has_meta('watch_call_on_notify'):
    return
  var callable_array = obj.get_meta('watch_call_on_notify')
  remove_callable_from_dict(callable_array, notename, fn)
  
func notify(obj: Object, notename: String, args: Array = []):
  if not obj.has_meta('watch_call_on_notify'):
    return
  var callable_array = obj.get_meta('watch_call_on_notify')
  call_callable(callable_array, notename, args)



func call_on_child_added_to_group(obj: Object, groupname: String, fn: Callable):
  var callable_array
  if not obj.has_meta('watch_call_on_child_added_to_group'):
    callable_array = {}
    obj.set_meta('watch_call_on_child_added_to_group', callable_array)
  else:
    callable_array = obj.get_meta('watch_call_on_child_added_to_group')
  add_callable_to_dict(callable_array, groupname, fn)
  
func stop_calling_on_child_added_to_group(obj: Object, groupname: String, fn: Callable):
  if not obj.has_meta('watch_call_on_child_added_to_group'):
    return
  var callable_array = obj.get_meta('watch_call_on_child_added_to_group')
  remove_callable_from_dict(callable_array, groupname, fn)
  
func add_child_to_group(obj: Object, child: Object, groupname: String):
  child.add_to_group(groupname)
  if not obj.has_meta('watch_call_on_child_added_to_group'):
    return
  var callable_array = obj.get_meta('watch_call_on_child_added_to_group', null)
  call_callable(callable_array, groupname, [])


func call_on_child_removed_from_group(obj: Object, groupname: String, fn: Callable):
  var callable_array
  if not obj.has_meta('watch_call_on_child_removed_from_group'):
    callable_array = {}
    obj.set_meta('watch_call_on_child_removed_from_group', callable_array)
  else:
    callable_array = obj.get_meta('watch_call_on_child_removed_from_group', null)
  add_callable_to_dict(callable_array, groupname, fn)
  
func stop_calling_on_child_removed_from_group(obj: Object, groupname: String, fn: Callable):
  if not obj.has_meta('watch_call_on_child_removed_from_group'):
    return
  var callable_array = obj.get_meta('watch_call_on_child_removed_from_group', null)
  remove_callable_from_dict(callable_array, groupname, fn)
  
func remove_child_from_group(obj: Object, child: Object, groupname: String):
  child.remove_from_group(groupname)
  if not obj.has_meta('watch_call_on_child_removed_from_group'):
    return
  var callable_array = obj.get_meta('watch_call_on_child_removed_from_group', null)
  call_callable(callable_array, groupname, [])









