extends Node

@onready var character = Lib.get_parent_with_signal(self, "on_target_object_set")

func _ready():
  if character:
    character.connect("target_object_set",Callable(self,"on_target_object_set"))

func on_target_object_set():
  if character.target_object:
    character.target_point = character.target_object.global_position
