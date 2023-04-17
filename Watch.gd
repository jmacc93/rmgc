extends Node


#var ui_notifier: Node = Node.new()


#func call_on_set_meta(obj: Object, key: String, fn: Callable):
#  var callable_array
#  if not obj.has_meta('watch_call_on_set_meta'):
#    obj.set_meta('watch_call_on_set_meta', {})
#    callable_array = obj.get_meta('watch_call_on_set_meta')
#  else:
#    callable_array = obj.get_meta('watch_call_on_set_meta')
#  add_callable_to_dict(callable_array, key, fn)
  
#func stop_calling_on_set_meta(obj: Object, key: String, fn: Callable):
#  if not obj.has_meta('watch_call_on_set_meta'):
#    return
#  var callable_array = obj.get_meta('watch_call_on_set_meta')
#  remove_callable_from_dict(callable_array, key, fn)
  
#func set_object_meta(obj: Object, key: String, value: Variant):
#  obj.set_meta(key, value)
#  if not obj.has_meta('watch_call_on_set_meta'):
#    return
#  var callable_array = obj.get_meta('watch_call_on_set_meta')
#  call_callable(callable_array, key, [])



func call_on_remove_meta(obj: Object, key: String, fn: Callable):
  var callable_array
  if not obj.has_meta('watch_call_on_remove_meta'):
    obj.set_meta('watch_call_on_remove_meta', {})
    callable_array = obj.get_meta('watch_call_on_remove_meta')
  else:
    callable_array = obj.get_meta('watch_call_on_remove_meta')
  Lib.add_callable_to_dict(callable_array, key, fn)
  
func stop_calling_on_remove_meta(obj: Object, key: String, fn: Callable):
  if not obj.has_meta('watch_call_on_remove_meta'):
    return
  var callable_array = obj.get_meta('watch_call_on_remove_meta')
  Lib.remove_callable_from_dict(callable_array, key, fn)

func remove_object_meta(obj: Object, key: String):
  obj.remove_meta(key)
  if not obj.has_meta('watch_call_on_remove_meta'):
    return
  var callable_array = obj.get_meta('watch_call_on_remove_meta')
  Lib.call_callable(callable_array, key, [])



func call_on_notify(obj: Object, notename: String, fn: Callable):
  var callable_array
  if not obj.has_meta('watch_call_on_notify'):
    callable_array = {}
    obj.set_meta('watch_call_on_notify', callable_array)
  else:
    callable_array = obj.get_meta('watch_call_on_notify')
  Lib.add_callable_to_dict(callable_array, notename, fn)
  
func stop_calling_on_notify(obj: Object, notename: String, fn: Callable):
  if not obj.has_meta('watch_call_on_notify'):
    return
  var callable_array = obj.get_meta('watch_call_on_notify')
  Lib.remove_callable_from_dict(callable_array, notename, fn)
  
func notify(obj: Object, notename: String, args: Array = []):
  if not obj.has_meta('watch_call_on_notify'):
    return
  var callable_array = obj.get_meta('watch_call_on_notify')
  Lib.call_callable(callable_array, notename, args)



func call_on_child_added_to_group(obj: Object, groupname: String, fn: Callable):
  var callable_array
  if not obj.has_meta('watch_call_on_child_added_to_group'):
    callable_array = {}
    obj.set_meta('watch_call_on_child_added_to_group', callable_array)
  else:
    callable_array = obj.get_meta('watch_call_on_child_added_to_group')
  Lib.add_callable_to_dict(callable_array, groupname, fn)
  
func stop_calling_on_child_added_to_group(obj: Object, groupname: String, fn: Callable):
  if not obj.has_meta('watch_call_on_child_added_to_group'):
    return
  var callable_array = obj.get_meta('watch_call_on_child_added_to_group')
  Lib.remove_callable_from_dict(callable_array, groupname, fn)
  
func add_child_to_group(obj: Object, child: Object, groupname: String):
  child.add_to_group(groupname)
  if not obj.has_meta('watch_call_on_child_added_to_group'):
    return
  var callable_array = obj.get_meta('watch_call_on_child_added_to_group', null)
  Lib.call_callable(callable_array, groupname, [])


func call_on_child_removed_from_group(obj: Object, groupname: String, fn: Callable):
  var callable_array
  if not obj.has_meta('watch_call_on_child_removed_from_group'):
    callable_array = {}
    obj.set_meta('watch_call_on_child_removed_from_group', callable_array)
  else:
    callable_array = obj.get_meta('watch_call_on_child_removed_from_group', null)
  Lib.add_callable_to_dict(callable_array, groupname, fn)
  
func stop_calling_on_child_removed_from_group(obj: Object, groupname: String, fn: Callable):
  if not obj.has_meta('watch_call_on_child_removed_from_group'):
    return
  var callable_array = obj.get_meta('watch_call_on_child_removed_from_group', null)
  Lib.remove_callable_from_dict(callable_array, groupname, fn)
  
func remove_child_from_group(obj: Object, child: Object, groupname: String):
  child.remove_from_group(groupname)
  if not obj.has_meta('watch_call_on_child_removed_from_group'):
    return
  var callable_array = obj.get_meta('watch_call_on_child_removed_from_group', null)
  Lib.call_callable(callable_array, groupname, [])









