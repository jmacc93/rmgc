extends Node


func call_method(obj: Object, method_name: String, args: Array = []):
  var method = get_object_meta(obj, method_name)
  if (method != null) and (method is Callable):
    return method.callv(args)
  else:
    push_error('call_method called on "', method_name, '" which isnt registered for ', self, ' (', str(self.name) if ('name' in self) else '', '')

func call_method_or(obj: Object, method_name: String, args: Array = [], default: Variant = null):
  var method = get_object_meta(obj, method_name)
  if (method != null) and (method is Callable):
    return method.callv(args)
  else:
    return default


func run_method(obj: Object, method_name: String, args: Array = []):
  var method = get_object_meta(obj, method_name)
  if (method != null) and (method is Callable):
    method.callv(args)
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
