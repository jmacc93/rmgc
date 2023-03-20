extends Node

@onready var target_point_parent = Lib.get_parent_with_method(self, "set_target_point")
@onready var mouse_position_parent = Lib.get_parent_with_method(self, "get_global_mouse_position")

func _process(_delta):
  if target_point_parent and mouse_position_parent:
    var mouse_position = target_point_parent.get_global_mouse_position()
    mouse_position_parent.set_target_point(mouse_position)
