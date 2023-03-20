extends Node

@onready var character = Lib.get_parent_with_method(self, "walk_by")

@export var disabled = false

@export var stay_distance = 50.0

func _process(_delta):
  if (not character) or disabled:
    return
  
  #find the point to move toward
  var target_point : Vector2
  if 'target_point' in character:
    target_point = character.target_point
  elif 'targeted_object' in character:  
    var target_object : Node2D = character.targeted_object
    if (not target_object) or (not is_instance_valid(target_object)):
      return
    target_point = target_object.global_position
  else:
    return
  
  var vec_to_target = character.global_position - target_point
  if vec_to_target.length() >= stay_distance:
    var adjusted_target_point = target_point + vec_to_target.normalized() * stay_distance
    var move_vec = (adjusted_target_point - character.global_position).normalized()
    character.walk_by(move_vec)
  



