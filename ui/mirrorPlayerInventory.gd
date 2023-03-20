extends Node

@onready var parent : Control = get_parent()

@onready var next_ui_mirror_time : int = 0
@export var ui_mirror_period = 300
@export var no_target_mirror_period = 100


#sync nodes synchronize inventory, equipment, etc nodes with ui nodes
func remove_sync_nodes():
  for sync_node in get_tree().get_nodes_in_group('ui_sync_node'):
    sync_node.queue_free()


func _process(delta):
  var current_time = Time.get_ticks_msec()
  if current_time < next_ui_mirror_time:
    return
  
  var ui_target = get_tree().get_first_node_in_group('ui_target')
  if not ui_target:
    remove_sync_nodes()
    next_ui_mirror_time = current_time + no_target_mirror_period
    return
  
  
  next_ui_mirror_time = current_time + ui_mirror_period
    
