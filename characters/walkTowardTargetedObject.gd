extends Node

var character_parent
var global_position_parent
    
@export var disabled = false

@export var stay_distance = 50.0


func _enter_tree():
  
  global_position_parent = Lib.get_parent_with_property(self, 'global_position')
  if not global_position_parent:
    push_error('No global position parent found')
    queue_free()    
    return

var frame_num = 0
func _process(_delta):
  if disabled:
    return
  
  frame_num += 1
  if frame_num % 2 == 0:
    return #skip 1 out of 2 frames
  
  #is there a target?
  var parent = get_parent()
  var target_object = Comp.get_prop(parent, 'target_object')
  if (target_object == null) or (not is_instance_valid(target_object)) or (not ('global_position' in target_object)):
    return
  
  var targets_position = target_object.global_position
  var vec_to_target = global_position_parent.global_position - targets_position
  if vec_to_target.length() >= stay_distance:
    var adjusted_target_point = targets_position + vec_to_target.normalized() * stay_distance
    var move_vec = (adjusted_target_point - global_position_parent.global_position).normalized()
    Comp.run_method(parent, 'walk_by', [move_vec])
  



