extends Node


func _enter_tree():
  var parent : Node2D = Lib.get_parent_in_group(self, 'character')
  if not parent:
    push_error('Node2D parent for player not found')
    return
  Lib.set_object_meta(parent, 'is_player', true)


func _exit_tree():
  var parent : Node2D = Lib.get_parent_in_group(self, 'character')
  if not parent:
    push_error('Node2D parent for player not found')
    return
  Lib.set_object_meta(parent, 'is_player', false)

