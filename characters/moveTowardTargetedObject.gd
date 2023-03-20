extends Node

var composite
var global_position_parent
    
@export var disabled = false

@export var stay_distance = 50.0


func _enter_tree():
  composite = Lib.get_parent_with_method(self, "new_getter")
  if not composite:
    push_error('No composite parent found')
    queue_free()
    return
  
  global_position_parent = Lib.get_parent_with_property(self, 'global_position')
  if not global_position_parent:
    push_error('No composite parent found')
    queue_free()    
    return


func _process(_delta):
  if disabled:
    return
  
  #is there a target?
  var target_object = composite.get_prop('target_object')
  if (target_object == null) or (not is_instance_valid(target_object)) or (not ('global_position' in target_object)):
    return
  
  var targets_position = target_object.global_position
  var vec_to_target = global_position_parent.global_position - targets_position
  if vec_to_target.length() >= stay_distance:
    var adjusted_target_point = targets_position + vec_to_target.normalized() * stay_distance
    var move_vec = (adjusted_target_point - global_position_parent.global_position).normalized()
    composite.walk_by(move_vec)
  



