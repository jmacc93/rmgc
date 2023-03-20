extends Node

@onready var shot = Lib.get_parent_with_signal(self, 'collided')

@export var hurt_parent = false

func _ready():
  shot.connect('collided', Callable(self, 'handle_collision'))

func handle_collision(collision):
  var body = collision.get_collider()
  if ('parent_object' in shot) and (shot.parent_object == body) and (not hurt_parent):
    return #dont hurt parent
  if body.has_method("hurt_by"):
    body.hurt_by(shot.damage, shot)
  elif body.has_method("damage_by"):
    body.hurt_by(shot.damage, shot)
  elif ("hp" in body):
    body.hp -= shot.damage
