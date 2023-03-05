extends Node

export var shot_resource : PackedScene

onready var character : Character
onready var parent : Node2D
onready var world : GameWorld

export var cast_speed = 5.0

func _ready():
  parent = Lib.get_parent_with_class(self, Node2D)
  character = Lib.get_parent_with_class(self, Character)
  world = Lib.get_parent_with_class(self, GameWorld)
  if character:
    character.connect("shoot", self, "on_shoot")

func on_shoot():
  if shot_resource:
    var shot = shot_resource.instance()
    if world:
      world.add_child(shot)
    else:
      get_node('/root').add_child(shot)
  
    shot.global_position = (parent.global_position if parent else character.global_position)
    if shot.has_method('cast_toward'):
      shot.cast_toward(character.target_point, cast_speed)
    elif ('velocity' in shot):
      shot.velocity = (character.target_point - shot.global_position).normalized() * cast_speed
