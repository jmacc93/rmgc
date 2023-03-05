extends KinematicBody2D

class_name Character

export var move_rate = 1.0

export var max_health = 100.0
export var current_health = 100.0

func _init():
  add_user_signal("shoot")

func move_by(vec: Vector2):
  if (vec.x == 0) and (vec.y == 0):
    return
  
  var collision = move_and_collide(vec * 60.0 * move_rate, true, true, true) #infinite_inertia, exclude_raycast_shapes, test_only
  if (not collision):
    global_position += vec
    return
  var collider = collision.collider
  
  var pass_through : bool = (('characters_pass_through' in collider) and collider.characters_pass_through) or (('obstructs_characters' in collider) and collider.obstructs_characters)
  global_position += vec if pass_through else collision.travel

var target_point : Vector2 = Vector2(0, 0) setget set_target_point

func set_target_point(new_point: Vector2):
  target_point = new_point

func shoot():
  emit_signal("shoot")
