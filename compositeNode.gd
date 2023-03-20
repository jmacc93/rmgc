extends Node

func add_signaler_to_dict(dict: Dictionary, key: String, value: Callable) -> bool:
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

func remove_signaler_to_dict(dict: Dictionary, key: String, value: Callable) -> bool:
  var existing_callable_array: Array = dict.get(key)
  if existing_callable_array:
    existing_callable_array.erase(value)
    return true
  else:
    return false

func call_signalers(dict: Dictionary, signalers_name: String, args: Array):
  var callable_array = dict.get(signalers_name)
  if callable_array == null:
    return
  for callable in callable_array:
    callable.callv(args)


var prop_getters = {} #prop_getters["property name"] : () -> Variant
func new_getter(prop: String, getter: Callable):
  if prop_getters.has(prop):
    push_error(self, ' trying to redefine property getter ', prop)
  prop_getters[prop] = getter
#  (func(): #satisfy when_getter_defined calls
#    var value = getter.call()
#    call_signalers(when_getter_defined_signalers, prop, [value])
#    when_getter_defined_signalers.erase(prop)
#  ).call_deferred()
func new_getters(props: Array, getter: Callable):
  for prop in props:
    new_getter(prop, getter)

func remove_getter(prop: String):
  if not prop_getters.has(prop):
    push_error(self, ' trying to remove non-existent property getter ', prop)
  prop_getters.erase(prop)
func remove_getters(props: Array):
  for prop in props:
    remove_getter(prop)

func has_getter(prop: String):
  return prop_getters.has(prop)

func get_prop(prop: String, default: Variant = null):
  var getter = prop_getters.get(prop, default)
  return getter.call() if (getter != null) else default
func get_first_prop_in(props: Array, default: Variant = null):
  for prop in props:
    var getter = prop_getters.get(prop)
    if getter != null:
      return getter.call()
  #none found, return default:
  return default

#var when_getter_defined_signalers = {}
#func when_getter_defined(prop: String, fn: Callable):
#  var getter = prop_getters.get(prop)
#  if getter:
#    var value = getter.call()
#    fn.call(value)
#  else:
#    add_signaler_to_dict(when_getter_defined_signalers, prop, fn)


var prop_setters = {} #prop_setters["property name"] : (new_value, old_value) -> void
var prop_set_signalers = {}
func new_setter(prop: String, callable: Callable):
  if prop_setters.has(prop):
    push_error(self, ' trying to redefine property setter ', prop)
  prop_setters[prop] = callable
func new_setters(props: Array, callable: Callable):
  for prop in props:
    new_setter(prop, callable)

func remove_setter(prop: String):
  if not prop_getters.has(prop):
    push_error(self, ' trying to remove non-existent property setter ', prop)
  prop_setters.erase(prop)
func remove_setters(props: Array):
  for prop in props:
    remove_setter(prop)

func has_setter(prop: String):
  return prop_setters.has(prop)

func set_prop(prop: String, new_value: Variant, and_signal = true):
  if prop_setters.has(prop):
    if and_signal:
      call_signalers(prop_set_signalers, prop, [new_value])
    var setter = prop_setters[prop]
    setter.call(new_value)
  else:
    push_error('set_prop called on ', prop, ' which isnt registered')
func set_first_prop_in(props: Array, new_value: Variant, and_signal = true) -> bool:
  for prop in props:
    if prop_setters.has(prop):
      if and_signal:
        call_signalers(prop_set_signalers, prop, [new_value])
      var setter = prop_setters[prop]
      setter.call(new_value)
      return true
  return false

func call_on_set(prop: String, callable: Callable):
  return add_signaler_to_dict(prop_set_signalers, prop, callable)

func call_on_set_in(props: Array, callable: Callable):
  for prop in props:
    call_on_set(prop, callable)


var method_dict = {}
var method_call_signalers = {}
func new_method(method_name: String, callable: Callable) -> bool:
  if method_dict.has(method_name):
    return false
  else:
    method_dict[method_name] = callable
    return true
func new_methods(method_names: Array, callable: Callable):
  for method_name in method_names:
    new_method(method_name, callable)

func override_callable(method_name: String, callable: Callable):
  method_dict[method_name] = callable

func remove_method(method_name: String) -> bool:
  if not method_dict.has(method_name):
    push_error(self, ' trying to remove non-existent method ', method_name)
  return method_dict.erase(method_name)
func remove_methods(method_names: Array):
  for method_name in method_names:
    remove_setter(method_name)

func has_composite_method(method_name: String) -> bool:
  return method_dict.has(method_name)

func call_method(method_name: String, args: Array = [], and_signal = true):
  var method = method_dict.get(method_name)
  if method:
    var ret = method.callv(args)
    if and_signal:
      call_signalers(method_call_signalers, method_name, args)
    return ret
  else:
    push_error('call_method called on "', method_name, '" which isnt registered for ', self, ' (', str(self.name) if ('name' in self) else '', '')
func call_method_from(method_names: Array, args: Array = [], and_signal = false):
  for method_name in method_names:
    if method_dict.has(method_name):
      return call_method(method_name, args, and_signal)

func run_method(method_name: String, args: Array = [], and_signal = true) -> bool:
  var method = method_dict.get(method_name)
  if method:
    method.callv(args)
    if and_signal:
      call_signalers(method_call_signalers, method_name, args)
    return true
  else:
    return false
func run_first_method_in(method_names: Array, args: Array = [], and_signal = true) -> bool:
  for method_name in method_names:
    var output = run_method(method_name, args, and_signal)
    if output:
      return output
  return false

func call_on_call(prop: String, callable: Callable):
  return add_signaler_to_dict(method_call_signalers, prop, callable)

func call_on_call_in(prop: String, callable: Callable):
  call_on_call(prop, callable)


var generic_signalers = {}
func call_on(notification_name: String, callable: Callable):
  return add_signaler_to_dict(generic_signalers, notification_name, callable)

func notify(notification_name: String, args: Array):
  call_signalers(generic_signalers, notification_name, args)


var object_registry = {}
func register_object(group: String, object: Object) -> bool:
  var existing_array = object_registry.get(group)
  if existing_array:
    if existing_array.has(object):
      return false
    else:
      existing_array.push_back(object)
      return true
  else:
    var new_array = [object]
    object_registry[group] = new_array
    return true
func unregister_object(group: String, object: Object) -> bool:
  var existing_array : Array = object_registry.get(group)
  if existing_array:
    var object_index = existing_array.find(object)
    if object_index != -1:
      existing_array.remove_at(object_index)
      return true
    else:
      return false
  else:
    return false

func get_registered_objects(group: String):
  var existing_array = object_registry.get(group)
  return existing_array if (existing_array != null) else []




