extends Node

var composite


func _enter_tree():
  composite = Lib.get_parent_with_method(self, "new_getter")
  if not composite:
    push_error('No composite parent found')
    return
  
  composite.call_on_set_in(['hp', 'health'], Callable(self, 'on_set_hp'))


func on_set_hp(new_hp):
  if new_hp <= 0:
    composite.call_method('die', [])
