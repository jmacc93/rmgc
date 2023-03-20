extends Node

@export var parent_object_property_name = 'parent_object'

func _enter_tree():
  var composite = Lib.get_parent_with_method(self, "new_getter")
  if not composite:
    push_error('No composite parent found')
    return
  
  composite.call_on_set(parent_object_property_name, func(parent_object):
    if not composite.has_method('add_collision_exception_with'):
      return
    
    if parent_object:
      composite.add_collision_exception_with(parent_object)
    else:
      composite.remove_collision_exception_with(parent_object)
  )
