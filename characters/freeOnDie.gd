extends Node

var composite

func _enter_tree():
  composite = Lib.get_parent_with_method(self, "new_getter")
  if not composite:
    push_error('No composite parent found')
    return
  
  composite.new_method('die', Callable(self, 'on_die'))


func on_die():
  composite.queue_free()
