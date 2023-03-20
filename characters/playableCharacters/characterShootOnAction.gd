extends Node

@onready var character = Lib.get_parent_with_method(self, "shoot")

@export var repeatedly = true

func _input(_event: InputEvent):
  if ((not repeatedly) and Input.is_action_just_pressed("shoot")) and character:
    character.shoot()

func _process(_delta):
  if repeatedly and Input.is_action_pressed("shoot") and character:
    character.shoot()
