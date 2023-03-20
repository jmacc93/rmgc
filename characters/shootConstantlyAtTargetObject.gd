extends Node

var character_composite

@export var disabled = false

@export var msecs_between_attacks = 200
var next_attack_time = 0

func _enter_tree():
  character_composite = Lib.get_parent_with_method(self, "new_getter")
  if not character_composite:
    push_error('No character_composite parent found')
    return


func find_main_attack_ability_and_attack():
  var main_attack_node_list = Lib.get_children_in_group(character_composite, 'main_attack')
  for attack_node in main_attack_node_list:
    if attack_node.has_method('attack'):
      attack_node.attack(character_composite)
    elif attack_node.has_method('run_method'): #its a composite
      attack_node.run_method('attack', [character_composite])


func _process(_delta):
  if disabled:
    return
  
  var current_time = Time.get_ticks_msec()
  if next_attack_time > current_time:
    return
  
  #shoot if character has target
  var target_object = character_composite.get_prop('target_object')
  if (target_object == null) or (not is_instance_valid(target_object)):
    return
  
  next_attack_time = current_time + msecs_between_attacks
  find_main_attack_ability_and_attack()
  
