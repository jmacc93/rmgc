extends Node

@export var faction_array : Array

var composite

func _enter_tree():
  composite = Lib.get_parent_with_method(self, "new_getter")
  if not composite:
    push_error('No parent composite found')
    return
  composite.new_getter('faction_array', Callable(self, 'get_faction_array'))

func get_faction_array():
  return get_faction_array
  
