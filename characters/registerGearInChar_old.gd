extends Node

var composite


func _enter_tree():
  composite = Lib.get_parent_with_method(self, "new_getter")
  if composite == null:
    push_error('No composite parent found')
    return


func _exit_tree():  
  var owner_character = composite.get_prop('owner_character')
  owner_character.unregister_object('gear', composite)


func _ready():
  var owner_character = composite.get_prop('owner_character')
  if owner_character == null:
    push_error('Gear has no owner')
    return
  
  owner_character.register_object('gear', composite)

