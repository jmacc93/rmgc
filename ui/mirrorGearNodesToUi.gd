extends Node

var composite

var gear_cell_resource : PackedScene = preload("res://ui/ui_gear_cell.tscn")


func _enter_tree():
  composite = Lib.get_parent_with_method(self, "new_getter")
  if composite == null:
    push_error('No composite parent found')
    return
  
  composite.connect('child_entered_tree', Callable(self, 'on_new_child'))


func _ready():
  for child in composite.get_children():
    if not child.is_in_group('gear'):
      continue
    on_new_child(child)


func on_new_child(child: Node):
  if not child.is_in_group('gear'):
    return
  var new_gear_cell = gear_cell_resource.instantiate()
  new_gear_cell.gear_node = child
  call_deferred('add_sibling', new_gear_cell)
