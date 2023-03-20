extends Node

#Use primarily to set parent gear composite node's owner to the grandparent composite node in character group

var composite

var owner_character

func _enter_tree():
  composite = Lib.get_parent_with_method(self, "new_getter")
  if composite == null:
    push_error('No composite parent found')
    return
    
  owner_character = Lib.get_parent_in_group(self, "character")
  if owner_character == null:
    push_error('No parent in character group found')
    return
  if not owner_character.has_method('new_getter'):
    push_error('Parent character is not a composite object')
    return
  
  composite.new_getter('owner_character', Callable(self, 'get_owner_character'))


func get_owner_character():
  return owner_character if is_instance_valid(owner_character) else null
