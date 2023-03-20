extends Node

@onready var shot = Lib.get_parent_with_signal(self, 'collided')

@export var except_parent = true

func _ready():
  shot.connect('collided', Callable(self, 'handle_collision'))
  if except_parent and (shot is PhysicsBody2D) and ('parent_object' in shot) and (shot.parent_object is PhysicsBody2D):
    shot.add_collision_exception_with(shot.parent_object)

func handle_collision(collision):
  var body = collision.get_collider()
  if body.has_meta('is_character'):
    if except_parent and ('parent_object' in shot) and (body == shot.parent_object):
      return
    shot.queue_free()
