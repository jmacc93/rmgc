extends Node

var composite
@export var faction : String

func _enter_tree():
  composite = Lib.get_parent_with_method(self, "new_getter")
  if not composite:
    push_error('No composite parent found')
    return
  composite.new_getter('faction_array', Callable(self, 'get_faction_array'))
  composite.new_method('in_faction', Callable(self, 'in_faction'))

func get_faction_array():
  if faction != '':
    return [faction]
  else:
    return []

func in_faction(test_faction: String):
  return faction == test_faction
