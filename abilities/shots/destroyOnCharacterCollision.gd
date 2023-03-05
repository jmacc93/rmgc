extends Node

onready var shot : Shot

func _ready():
  shot = Lib.get_parent_with_class(self, Shot)
  if shot and shot.has_method('add_collision_handler'):
    shot.add_collision_handler(self)

func handle_collision(collision):
  if (collision.collider is Character):
    shot.queue_free()
