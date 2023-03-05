extends Node

onready var character : Character = Lib.get_parent_with_class(self, Character)

func _process(delta):
  if character:
    var mouse_position = character.get_global_mouse_position()
    character.set_target_point(mouse_position)
