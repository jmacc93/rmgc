extends Node

var weapon_composite

@export var cast_speed = 5.0
@export var damage_mod = 1.0

@export var max_attack_rate = 20
@onready var attack_delay = int(float(10000) / float(max_attack_rate))
var next_attack_time = 0

@export var shot_resource : PackedScene


func _enter_tree():
  weapon_composite = Lib.get_parent_with_method(self, 'new_getter')
  if not weapon_composite:
    push_error('No weapon_composite parent found')
    return
  
  weapon_composite.new_methods(['shoot', 'attack'], Callable(self, 'attack'))


#shoot new shot toward target point / target object with shoot delay
func attack(shooter_object: Object) -> void:
  var current_time = Time.get_ticks_msec()
  if shot_resource and (next_attack_time < current_time):
    next_attack_time = current_time + attack_delay
    var shot = shot_resource.instantiate()
    
    #set shot origin
    var origin_position = weapon_composite.get_prop('shot_origin')
    if origin_position == null:
      origin_position = weapon_composite.global_position if ('global_position' in weapon_composite) else null
    if origin_position == null:
      origin_position = Lib.get_parent_with_property(self, 'global_position').global_position
    shot.global_position = origin_position
    
    get_viewport().add_child(shot)
    
    #set shot parent (the shot's creator)
    shot.set_prop('parent_object', shooter_object)
    
    var dmg = shot.get_first_prop_in(['dmg', 'damage'], 1.0)
    shot.set_first_prop_in(['dmg', 'damage'], dmg * damage_mod)
    
    #try shooting toward target if it exists
    var target_point = shooter_object.get_prop('target_point')
    if target_point == null:
      var target_object = shooter_object.get_prop('target_object')
      if target_object != null:
        target_point = target_object.global_position
    
    if target_point != null:
      if shot.run_method('cast_toward', [target_point, cast_speed]):
        return
      elif shot.run_method('shoot_in_dir', [(target_point - origin_position).normalized(), cast_speed]):
        return
      var shot_velocity = shot.get_prop('velocity')
      if shot_velocity != null:
        shot.set_prop('velocity', (target_point - origin_position).normalized() * cast_speed)
        return
      else:
        push_error('Shot has no way of being projected toward target point')
        return
      
    #else, try shooting in a direction
    var shoot_dir = shooter_object.get_prop('shoot_dir')
    if shoot_dir != null:
      shoot_dir = shoot_dir.normalized()
      if shot.run_method('shoot_in_dir', [shoot_dir.normalized(), cast_speed]):
        return
      var shot_velocity = shot.get_prop('shot_velocity')
      if shot_velocity != null:
        shot.set_prop('velocity', [shoot_dir.normalized() * cast_speed])
        return
      else:
        push_error('Shot has no way of being projected in shoot direction')
        return














