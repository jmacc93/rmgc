extends Node

#This library is primarily for the function `notify` below, and is probably deprecateable 


#Call the given function fn when `notify(obj, notename, [...])` is called
#This is analogous to connecting a function with a signal
#eg: Watch.call_on_notify(get_parent(), 'die', explode_on_death)
func call_on_notify(obj: Object, notename: String, fn: Callable):
  if not obj.has_meta('watch_call_on_notify'):
    #Create the `watch_call_on_notify` metadata property since it doesnt exist
    obj.set_meta('watch_call_on_notify', {})
  var callable_array = obj.get_meta('watch_call_on_notify')
  Lib.add_callable_to_dict(callable_array, notename, fn)

#Stop future calls to given fn when `notify` is called
func stop_calling_on_notify(obj: Object, notename: String, fn: Callable):
  if not obj.has_meta('watch_call_on_notify'):
    return
  var callable_array = obj.get_meta('watch_call_on_notify')
  Lib.remove_callable_from_dict(callable_array, notename, fn)
  
#Call all `call_on_notify`-registered functions registered with the given `notename`
#eg: if hp <= 0: Watch.notify(get_parent(), 'die', [])
func notify(obj: Object, notename: String, args: Array = []):
  if not obj.has_meta('watch_call_on_notify'):
    return
  var callable_array = obj.get_meta('watch_call_on_notify')
  Lib.call_callable(callable_array, notename, args)


#The remaining functions aren't used, but the *could* be!
#Registering signals to emit when adding / removing child nodes (ie: children of composite nodes) could be useful

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









