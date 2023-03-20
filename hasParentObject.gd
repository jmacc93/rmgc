extends Node

var composite

var parent_object

func _enter_tree():
  composite = Lib.get_parent_with_method(self, "new_getter")
  if not composite:
    push_error('No composite parent found')
    return
  
  composite.new_getter('parent_object', Callable(self, 'get_parent_object'))
  composite.new_setter('parent_object', Callable(self, 'set_parent_object'))


func get_parent_object():
  return parent_object if is_instance_valid(parent_object) else null
func set_parent_object(new_parent_object: Object):
  parent_object = new_parent_object
