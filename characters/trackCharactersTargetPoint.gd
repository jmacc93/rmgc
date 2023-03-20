extends Node

@onready var character = Lib.get_parent_with_class(self, "Character")
@onready var parent : Node2D = Lib.get_parent_with_class(self, "Node2D")

func _process(delta):
  if character and parent:
    parent.global_position = character.target_point
