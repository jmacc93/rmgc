extends Node

@export var spd = 10.0

var composite

@export var disabled = false

var last_velocity : Vector2


func _enter_tree():
  composite = Lib.get_parent_with_method(self, "new_getter")
  if not composite:
    push_error('No composite parent found')
    return
  if not ('velocity' in composite):
    push_error('No velocity in composite parent')
    return
  if not composite.has_method('move_and_slide'):
    push_error('No move_and_slide in composite parent')
    return
  
  composite.new_getters(['spd', 'speed'], Callable(self, 'get_spd'))
  composite.new_setters(['spd', 'speed'], Callable(self, 'set_spd'))
  
  composite.new_getter('velocity', Callable(self, 'get_velocity'))
  composite.new_setter('velocity', Callable(self, 'set_velocity'))
  
  composite.new_method('walk_by', Callable(self, 'walk_by'))


func _ready():
  composite.set_prop('spd', spd)


func set_spd(new_spd):
  spd = new_spd
func get_spd():
  return spd


func set_velocity(new_velocity):
  composite.velocity = new_velocity
func get_velocity():
  return last_velocity


#move in a particular direction, with collisions
func walk_by(vec: Vector2):
  if disabled:
    return

  if (vec.x == 0) and (vec.y == 0):
    return
  
  composite.velocity += vec * 6.0 * spd
  last_velocity = composite.velocity


func _physics_process(_delta):
  if composite.velocity.x == 0 and composite.velocity.y == 0:
    return
  
  composite.move_and_slide()
  composite.velocity = Vector2(0, 0)
