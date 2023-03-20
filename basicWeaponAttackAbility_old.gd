extends Node

@export var shot_resource : PackedScene

@onready var shoot_signaler : Node2D
@onready var origin : Node2D
@onready var world : GameWorld

@export var cast_speed = 5.0
@export var damage_mod = 1.0

@export var max_attack_rate = 20
@onready var attack_delay = int(float(10000) / float(max_attack_rate))
var next_attack_time = 0


#get parents and connect signals
func _ready():
  origin = Lib.get_parent_with_class(self, "Node2D")
  if not origin:
    push_error('no parent fould with class Node2D')
  shoot_signaler = Lib.get_parent_with_signal(self, "shot")
  if not shoot_signaler:
    push_error('no parent fould with "shot" signal')
  world = Lib.get_parent_with_class(self, "GameWorld")
  if shoot_signaler:
    shoot_signaler.connect("shot", Callable(self, "on_shoot"))


#shoot new shot toward target point / target object with shoot delay
func on_shoot():
  var current_time = Time.get_ticks_msec()
  if shot_resource and (next_attack_time < current_time):
    next_attack_time = current_time + attack_delay
    var shot = shot_resource.instantiate()
    
    #set shot parent to character
    shot.global_position = (origin.global_position if origin else shoot_signaler.global_position)
    if ('parent_object' in shot):
      shot.parent_object = shoot_signaler
    
    shot.damage *= damage_mod
    
    if world:
      world.add_child(shot)
    else:
      get_viewport().add_child(shot)
    
    #try shooting toward target if it exists
    var target_point = null
    if 'target_point' in shoot_signaler:
      target_point = shoot_signaler.target_point
    elif shoot_signaler.target_object and is_instance_valid(shoot_signaler.targeted_object):
      target_point = shoot_signaler.target_object.global_position
    if target_point:
      if shot.has_method('shoot_toward'):
        shot.cast_toward(target_point, cast_speed)
      elif shot.has_method('shoot_in_dir'):
        shot.shoot_in_dir((target_point - origin.global_position).normalized(), cast_speed)
      elif 'velocity' in shot:
        shot.velocity = (target_point - origin.global_position).normalized() * cast_speed
      else:
        push_error('Shot has no way of being projected toward target point')
      return
      
    #else, try shooting in a direction
    var cast_dir = null
    if 'shoot_dir' in shoot_signaler:
      cast_dir = shoot_signaler.shoot_dir.normalized()
    if cast_dir:
      if shot.has_method('shoot_in_dir'):
        shot.shoot_in_dir(cast_dir.normalized(), cast_speed)
      elif 'velocity' in shot:
        shot.velocity = cast_dir.normalized() * cast_speed
      else:
        push_error('Shot has no way of being projected in shoot direction')
      return
    















