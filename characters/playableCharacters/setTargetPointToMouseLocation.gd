extends Node

var composite

var mouse_position_parent

var target_point : Vector2

func _enter_tree():
  composite = Lib.get_parent_with_method(self, "new_getter")
  if not composite:
    push_error('No composite parent found')
    queue_free()
    return
  mouse_position_parent = Lib.get_parent_with_method(self, 'get_global_mouse_position')
  if not mouse_position_parent:
    push_error('No get_global_mouse_position parent found')
    queue_free()
    return
  
  composite.new_getter('target_point', Callable(self, 'get_target_point'))


func get_target_point():
  return target_point


func _process(_delta):
  target_point = mouse_position_parent.get_global_mouse_position()
