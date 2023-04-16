extends Area2D

@onready var character = Lib.get_parent_with_property(self, "faction_array")

func __init():
  assert(false)


#does character love or hate obj?
func is_enemy_factioned_object(obj):
  for char_faction in character.faction_array:
    #if any of parent char's factions are in obj's faction_array then they're best buds
    var char_faction_in_object = (obj.faction_array.find(char_faction) != -1)
    if char_faction_in_object:
      return false #loves
  return true #hates


#is body an enemy? then target. Return true if targeted something
func test_and_switch_target_to_body(body):
  if ("faction_array" in character):
    if ("faction_array" in body):
      var obj_is_enemy = is_enemy_factioned_object(body)
      if obj_is_enemy:
        character.target_object = body
        return true
  elif (("hates_everyone" in character) and character.hates_everyone) and (body.is_class("Character")):
    character.target_object = body
    return true
  return false
  


#target characters and factioned objects that enter
func _on_targetNearestNonfaction_body_entered(body):
  if not character:
    return
  
  #already has a target?
  if character.target_object:
    return
  
  test_and_switch_target_to_body(body)


#untarget active target if its far away, and then get a new target if there are any
func _on_targetNearestNonfaction_body_exited(body):
  if not character:
    return
  
  #dont untarget current target if it didnt just leave
  if body != character.target_object:
    return
  
  #get a new target, if there is one
  character.target_object = null
  for overlapping_body in get_overlapping_bodies():
    var has_new_target = test_and_switch_target_to_body(overlapping_body)
    if has_new_target:
      return


#move target point to targeted object
func _process(_delta):
  if not character:
    return
  
  if character.target_object and is_instance_valid(character.target_object):
    character.set_target_point(character.target_object.global_position)
  else:
    character.target_object = null










