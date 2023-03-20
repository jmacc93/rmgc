extends Node

var character_composite

@export var repeatedly = true
@export var action = 'shoot'

func _enter_tree():
  character_composite = Lib.get_parent_with_method(self, "new_getter")
  if not character_composite:
    push_error('No character_composite parent found')
    queue_free()
    return

var pressed = false


func find_main_attack_ability_and_attack():
  var main_attack_node_list = Lib.get_children_in_group(character_composite, 'main_attack')
  for attack_node in main_attack_node_list:
    if attack_node.has_method('attack'):
      attack_node.attack(character_composite)
    elif attack_node.has_method('run_method'): #its a composite
      attack_node.run_method('attack', [character_composite])


func _unhandled_input(_event):
  if Input.is_action_just_pressed(action):
    pressed = true
    find_main_attack_ability_and_attack()

func _input(_event):
  if Input.is_action_just_released(action):
    pressed = false

func _process(_delta):
  if repeatedly and pressed:
    find_main_attack_ability_and_attack()
