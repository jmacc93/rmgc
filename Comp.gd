extends Node


func call_method(obj: Object, method_name: String, args: Array = []):
  var method = get_object_meta(obj, method_name)
  if (method != null) and (method is Callable):
    return method.callv(args)
  elif obj.has_method(method_name):
    return obj.callv(method_name, args)
  else:
    push_error('call_method called on "', method_name, '" which isnt registered for ', self, ' (', str(self.name) if ('name' in self) else '', '')


func call_method_or(obj: Object, method_name: String, args: Array = [], default: Variant = null):
  var method = get_object_meta(obj, method_name)
  if (method != null) and (method is Callable):
    return method.callv(args)
  elif obj.has_method(method_name):
    return obj.callv(method_name, args)
  else:
    return default


func run_method(obj: Object, method_name: String, args: Array = []):
  var method = get_object_meta(obj, method_name)
  if (method != null) and (method is Callable):
    method.callv(args)
    return true
  elif obj.has_method(method_name):
    obj.callv(method_name, args)
    return true
  else:
    return false


func get_object_meta(obj: Object, prop: String, default: Variant = null) -> Variant:
  if obj.has_meta(prop):
    var ret = obj.get_meta(prop)
    if (typeof(ret) != TYPE_OBJECT) or is_instance_valid(ret):
      return ret
    else:
      return default
  else:
    return default


#synonym of get_object_meta
func getmeta(obj: Object, prop: String, default: Variant = null) -> Variant:
  return get_object_meta(obj, prop, default)


func has_prop(obj: Object, prop: String) -> bool:
  return ((prop in obj) or obj.has_meta(prop) or obj.has_method(prop))


func get_prop(obj: Object, prop: String, default: Variant = null) -> Variant:
  if prop in obj:
    var ret = obj.get(prop)
    return ret if ((typeof(ret) != TYPE_OBJECT) or is_instance_valid(ret)) else default
  elif obj.has_meta(prop):
    var ret = obj.get_meta(prop)
    return ret if ((typeof(ret) != TYPE_OBJECT) or is_instance_valid(ret)) else default
  else:
    return default


func satisfy_call_when_has_prop(obj: Object, prop: String, fn: Callable):
  fn.call()
  Watch.stop_calling_on_set_meta(obj, prop, satisfy_call_when_has_prop.bind(obj, prop, fn))
  Watch.stop_calling_on_set_prop(obj, prop, satisfy_call_when_has_prop.bind(obj, prop, fn))

func call_when_has_prop(obj: Object, prop: String, fn: Callable):
  #already has object property or meta:
  if has_prop(obj, prop):
    fn.call()
    return
  #doesn't have meta yet:
  Watch.call_on_set_prop(obj, prop, satisfy_call_when_has_prop.bind(obj, prop, fn))
  Watch.call_on_set_meta(obj, prop, satisfy_call_when_has_prop.bind(obj, prop, fn))
  
func stop_calling_when_has_prop(obj: Object, prop: String, fn: Callable):
  Watch.stop_calling_on_set_prop(obj, prop, satisfy_call_when_has_prop.bind(obj, prop, fn))
  Watch.stop_calling_on_set_meta(obj, prop, satisfy_call_when_has_prop.bind(obj, prop, fn))



func call_on_set_prop(obj: Object, prop: String, fn: Callable):
  if not obj.has_meta('watch_call_on_set_prop'):
    obj.set_meta('watch_call_on_set_prop', {})
  var callable_array = obj.get_meta('watch_call_on_set_prop')
  Watch.add_callable_to_dict(callable_array, prop, fn)

func call_on_set_prop_and_now(obj: Object, prop: String, fn: Callable):
  fn.call()
  call_on_set_prop(obj, prop, fn)

  
func stop_calling_on_set_prop(obj: Object, prop: String, fn: Callable):
  if not obj.has_meta('watch_call_on_set_prop'):
    return
  var callable_array = obj.get_meta('watch_call_on_set_prop')
  Watch.remove_callable_from_dict(callable_array, prop, fn)


func set_prop(obj: Object, prop: String, value: Variant):
  if prop in obj:
    Watch.set_object_prop(obj, prop, value)
  else:
    Watch.set_object_meta(obj, prop, value)
  if not obj.has_meta('watch_call_on_set_prop'):
    return
  var callable_array = obj.get_meta('watch_call_on_set_prop')
  Watch.call_callable(callable_array, prop, [])


#remove meta values and set real properties to default
func remove_prop(obj: Object, prop: String, default = null):
  if prop in obj:
    Watch.set_object_prop(obj, prop, default)
  else:
    Watch.remove_object_meta(obj, prop)
  if not obj.has_meta('watch_call_on_remove_prop'):
    return
  var callable_array = obj.get_meta('watch_call_on_remove_prop')
  Watch.call_callable(callable_array, prop, [])


func get_parent_with_prop(start_node: Node, prop_name: String):
  var current_node = start_node.get_parent()
  while current_node:
    if has_prop(current_node, prop_name):
      return current_node
    else:
      current_node = current_node.get_parent()
  return null




















