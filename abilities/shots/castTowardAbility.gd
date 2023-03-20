extends Node

var composite
var velocity_parent

func _enter_tree():
  composite = Lib.get_parent_with_method(self, "new_getter")
  if not composite:
    push_error('No composite parent found')
    return
  
  velocity_parent = Lib.get_parent_with_property(self, 'velocity')
  if not velocity_parent:
    push_error('No velocity parent found')
    return
  
  composite.new_method('cast_toward', Callable(self, 'cast_toward'))
  

func cast_toward(toward_point: Vector2, speed: float):
  velocity_parent.velocity = (toward_point - velocity_parent.global_position).normalized() * speed



