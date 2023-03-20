extends CharacterBody2D

class_name Shot
var type = "shot"

@export var disabled = false

var damage = 1.0

var parent_object : Object

signal collided(collision)


func _physics_process(_delta):
  if disabled:
    return
  
  set_velocity(velocity)
  move_and_slide()
  for i in range(0, get_slide_collision_count()):
    var collision = get_slide_collision(i)
    emit_signal('collided', collision)
  






