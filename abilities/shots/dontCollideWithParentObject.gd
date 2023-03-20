extends Node


var composite

func _enter_tree():
  composite = Lib.get_parent_with_method(self, "new_getter")
  if not composite:
    push_error('No composite parent found')
    return
  
  composite.call_on('collision', Callable(self, 'on_collision'))
  composite.call_on_set('parent_object', func(parent_object):
    if not composite.has_method('add_collision_exception_with'):
      return
    
    if except_parent and parent_object:
      composite.add_collision_exception_with(parent_object)
    else:
      composite.remove_collision_exception_with(parent_object)
  )

