extends Node

var composite

var target_point : Vector2

@onready var debug_point = $DebugPoint

var mirrored_target_object

func _enter_tree():
  composite = Lib.get_parent_with_method(self, "new_getter")
  if not composite:
    push_error('No composite parent found')
    queue_free()
    return
  
  composite.call_on_set('target_object', Callable(self, 'on_new_target_object'))
  
  composite.new_getter('target_point', Callable(self, 'get_target_point'))


func on_new_target_object(new_target_object):
  mirrored_target_object = new_target_object

func _process(_delta):
  if (mirrored_target_object != null) and ('global_position' in mirrored_target_object):
    target_point = mirrored_target_object.global_position
    if debug_point != null:
      debug_point.global_position = target_point


func get_target_point():
  return target_point
