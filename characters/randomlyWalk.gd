extends Node

var composite
var global_position_parent

@onready var debug_point : Node2D = get_node_or_null("debugPoint")

@export var disabled = false

@export var movement_rate = 20.0

@export var move_to_radius = 20.0
var move_to_point = Vector2(0.0, 0.0)
var next_move_to_time = 0.0
var next_move_point_delay_ms = 1000


func _enter_tree():
  composite = Lib.get_parent_with_method(self, "new_getter")
  if not composite:
    push_error('No composite parent found')
    return
  
  global_position_parent = Lib.get_parent_with_property(self, "global_position")
  if not global_position_parent:
    push_error('No global position parent found')
    return
 

func _process(delta):
  if disabled:
    return
  
  #find a new point to move to if close or old point is old
  var current_time = Time.get_ticks_msec()
  var move_to_vec = move_to_point - global_position_parent.global_position
  if (current_time > next_move_to_time) or (move_to_vec.length() < 1.0):
    move_to_point = global_position_parent.global_position + Lib.cs_vec(randf_range(0.0, 2*PI)) * move_to_radius
    next_move_to_time = current_time + next_move_point_delay_ms
    move_to_vec = move_to_point - global_position_parent.global_position
  
  #move toward that point
  composite.call_method('walk_by', [move_to_vec.normalized() * movement_rate * delta])
  
  if debug_point:
    debug_point.global_position = move_to_point

