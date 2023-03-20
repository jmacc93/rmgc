extends Node

@onready var character = Lib.get_parent_with_property(self, "target_object")

func _process(_delta):
  if (not character):
    return
  
  #shoot if character has target
  var target_object : Node2D = character.target_object
  if target_object and is_instance_valid(target_object):
    character.shoot()
  
