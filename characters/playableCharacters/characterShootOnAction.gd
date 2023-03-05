extends Node

onready var character : Character = Lib.get_parent_with_class(self, Character)

func _input(event: InputEvent):
  if Input.is_action_just_pressed("shoot") and character:
    character.shoot()
