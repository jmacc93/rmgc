extends Node

var composite
var body_parent


func _enter_tree():
  composite = Lib.get_parent_with_method(self, 'call_signalers')
  if not composite:
    push_error('No parent composite found')
    return
  
  body_parent = Lib.get_parent_with_class(self, 'PhysicsBody2D')
  if not body_parent:
    push_error('No parent physics body found')
    return
  
  composite.new_getter('velocity', Callable(self, 'get_velocity'))
  

func get_velocity():
  return body_parent.velocity


func _physics_process(_delta):
  if body_parent.velocity.x == 0 and body_parent.velocity.y == 0:
    return
  
  body_parent.move_and_slide()
  for i in range(0, body_parent.get_slide_collision_count()):
    composite.notify('collision', [body_parent.get_slide_collision(i)])
