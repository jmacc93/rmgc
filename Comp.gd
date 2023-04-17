extends Node

#This library is for working with composite nodes
#A composite node is one which looks like a regular instantiated class object, but
#has its methods, properties, etc provided to it by child nodes' scripts


#Helper function to get metadata property with default
func _get_object_meta(obj: Object, prop: String, default: Variant = null) -> Variant:
  if obj.has_meta(prop):
    var ret = obj.get_meta(prop)
    #Is it still valid? (not checking this will cause an error when it isn't valid)
    if (typeof(ret) != TYPE_OBJECT) or is_instance_valid(ret):
      return ret
    return default
  else:
    return default

#This gets the closest parent from start_node (as in fewest get_parent calls) with the given property
func get_parent_with_prop(start_node: Node, prop_name: String):
  var current_node = start_node.get_parent()
  while current_node:
    if has_prop(current_node, prop_name):
      return current_node
    else:
      current_node = current_node.get_parent()
  return null


#Calling composite methods ##############################
#########################################################

#A composite object's methods are either real methods (eg: `obj.foo()`) or
#metadata callables (eg: `obj.get_meta('foo').call()`)

#Call a method and return the result, eg: var res = Comp.call_method(character, 'hurt_by', [100])
func call_method(obj: Object, method_name: String, args: Array = []):
  #Try calling by method (ie: object method)
  if obj.has_method(method_name):
    return obj.callv(method_name, args)
  
  #Try getting metadata callable and calling that
  var method = _get_object_meta(obj, method_name)
  if (method != null) and (method is Callable):
    return method.callv(args)
  
  push_error('call_method called on "', method_name, '" which isnt registered for ', self, ' (', str(self.name) if ('name' in self) else '', '')

#Call a method and return the result, or return a default if the method isn't found
func call_method_or(obj: Object, method_name: String, args: Array = [], default: Variant = null):
  #Try calling by method (ie: object method)
  if obj.has_method(method_name):
    return obj.callv(method_name, args)
  
  #Try getting metadata callable and calling that
  var method = _get_object_meta(obj, method_name)
  if (method != null) and (method is Callable):
    return method.callv(args)
  
  return default

#Call a method and return true if the method was found, or false if it wasnt found
func run_method(obj: Object, method_name: String, args: Array = []):
  #Try calling by method (ie: object method)
  if obj.has_method(method_name):
    obj.callv(method_name, args)
    return true
  
  #Try getting metadata callable and calling that
  var method = _get_object_meta(obj, method_name)
  if (method != null) and (method is Callable):
    method.callv(args)
    return true
  
  return false


#Getting, setting, and signaling properties #############
#########################################################

#When want to be able to watch for property changes from other composite child nodes
#Thats what the next six functions (call_when_has_prop and call_on_set_prop -related functions) are for 

#The next three are for when a prop is first defined

#Helper function, for use by call_when_has_prop
func satisfy_call_when_has_prop(obj: Object, prop: String, fn: Callable):
  fn.call()
  Comp.stop_calling_on_set_prop(obj, prop, satisfy_call_when_has_prop.bind(obj, prop, fn))

#Call given fn when property prop changes (when set_prop is called on the property)
#eg, in an _enter_tree: call_when_has_prop(get_parent(), 'hp', set_hp_to_50_percent)
func call_when_has_prop(obj: Object, prop: String, fn: Callable):
  #already has object property or meta:
  if has_prop(obj, prop):
    fn.call()
    return
  #doesn't have prop yet:
  Comp.call_on_set_prop(obj, prop, satisfy_call_when_has_prop.bind(obj, prop, fn))

#Prevent a previously registered call_when_has_prop function from calling
func stop_calling_when_has_prop(obj: Object, prop: String, fn: Callable):
  if not obj.has_meta('comp_call_on_set_prop'):
    return
  var callable_array = obj.get_meta('comp_call_on_set_prop')
  Lib.remove_callable_from_dict(callable_array, prop, fn)


#The next three are for whenever a prop changes

#Call given fn when property prop changes
#note: the function receives no parameters, so you have to get the new property value inside the function
#eg: call_on_set_prop(get_parent(), 'hp', retaliate_on_hurt)
func call_on_set_prop(obj: Object, prop: String, fn: Callable):
  if not obj.has_meta('comp_call_on_set_prop'):
    obj.set_meta('comp_call_on_set_prop', {})
  var callable_array = obj.get_meta('comp_call_on_set_prop')
  Lib.add_callable_to_dict(callable_array, prop, fn)

#Call the given fn when prop changes, and immediately
#eg: call_on_set_prop_and_now(get_parent(), 'hp', update_hp_display) #<- update the display now and when 'hp' changes
func call_on_set_prop_and_now(obj: Object, prop: String, fn: Callable):
  fn.call()
  call_on_set_prop(obj, prop, fn)

#Un-register a previously registered call_on_set_prop function so it no longer is called when a prop changes
func stop_calling_on_set_prop(obj: Object, prop: String, fn: Callable):
  if not obj.has_meta('comp_call_on_set_prop'):
    return
  var callable_array = obj.get_meta('comp_call_on_set_prop')
  Lib.remove_callable_from_dict(callable_array, prop, fn)


#The next four are self-descriptive and correspond with the usual property-related functions for Objects

#Check if given object obj has the given property
#note: regular class-object methods (eg: obj.foo()) are also checked in this (eg: `has_prop(obj, 'foo')` is true)
func has_prop(obj: Object, prop: String) -> bool:
  return ((prop in obj) or obj.has_meta(prop) or obj.has_method(prop))

#Set or define a property in the given object, then call any call_on_set_prop functions
#Analogous to `obj.set(prop, value)`
#eg: set_prop(get_parent(), 'hp', 100)
func set_prop(obj: Object, prop: String, value: Variant):
  #Use obj's object property if it has one
  if prop in obj:
    obj.set(prop, value)
  #Otherwise use metadata
  else:
    obj.set_meta(prop, value)
  
  #Call call_on_set_prop functions:
  if not obj.has_meta('comp_call_on_set_prop'):
    return
  var callable_array = obj.get_meta('comp_call_on_set_prop')
  Lib.call_callable(callable_array, prop, [])

#Get a property from an object
#Analogous to `obj.get(prop)`
#eg: var hp = get_prop(get_parent(), 'hp', 0)
func get_prop(obj: Object, prop: String, default: Variant = null) -> Variant:
  #Does obj have an object property with that name?
  if prop in obj:
    var ret = obj.get(prop)
    return ret if ((typeof(ret) != TYPE_OBJECT) or is_instance_valid(ret)) else default
  
  #Does object has metadata with that name?
  if obj.has_meta(prop):
    var ret = obj.get_meta(prop)
    return ret if ((typeof(ret) != TYPE_OBJECT) or is_instance_valid(ret)) else default
  
  return default

#Remove metadata values completely and set Object properties to default
func remove_prop(obj: Object, prop: String, default = null):
  #For Object properties:
  if prop in obj:
    obj.set(prop, default)
    return
  
  #For metadata:
  obj.remove_meta(prop)
    



















