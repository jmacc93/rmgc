extends Node

@onready var shot = Lib.get_parent_with_signal(self, 'collided')

func _ready():
  shot.connect('collided', Callable(self, 'handle_collision'))

const wall_bit = 1
func handle_collision(collision):
  var body = collision.get_collider()
  if body.get_collision_layer_value(wall_bit):
    shot.queue_free()
