extends CharacterBody2D

class_name Character

@export var disabled = false

@export var speed = 10.0

@export var max_hp = 100.0
@export var hp = 100.0
@export var hp_regen = 1.0 #hp / second

@export var mdef = 1.0 #multiplicative defence, divides damage taken
@export var adef = 0.0 #additive defence, subtracts from damage taken up to 0

@export var faction_array : Array

signal shot
signal target_point_set
signal target_object_set
signal hurt(dmg, damager)
signal killed(killer)
signal healed(hp_change)
signal collided(collision)
signal stat_changed(stat_name, previus_value, inducer_object)


#take damage (death handled in component nodes)
var should_die = true #set to false to artificially prevent death in killed signal handler
func hurt_by(dmg: float, damager: Object = null):
  if disabled:
    return
  
#  var damager_parent = damager.parent_object #might be null
  
  var damager_adef_mod = abs(damager.adef_mod if ('adef_mod' in damager) else 1.0)
  var final_dmg = max(dmg / sqrt(mdef) - max(adef - damager_adef_mod, 0), 0)
  var prev_hp = hp
  hp -= final_dmg
  
  emit_signal('stat_changed', 'hp', prev_hp, damager)
  emit_signal("hurt", final_dmg, damager)


#move in a particular direction, with collisions
func walk_by(vec: Vector2):
  if disabled:
    return

  if (vec.x == 0) and (vec.y == 0):
    return

  velocity += vec * 6.0 * speed


#move in direction last move vec was set to
func _physics_process(_delta):
  if disabled:
    return
  
  if (velocity.x == 0) and (velocity.y == 0):
    return
  
  move_and_slide()
  velocity = Vector2(0, 0)
  for i in range(0, get_slide_collision_count()):
    var collision = get_slide_collision(i)
    emit_signal('collided', collision)


#regenerate health
func _process(delta):
  if disabled:
    return
  
  if hp < max_hp:
    var hp_change = hp_regen * delta
    hp = min(max_hp, hp + hp_change)
    emit_signal("healed", hp_change)


#target object: which object we want to attack
var target_object: Node2D : set = set_target_object
func set_target_object(obj: Node2D):
  target_object = obj
  emit_signal("target_object_set")


#target point: which point we attack towards
var target_point : Vector2 = Vector2(0, 0) : set = set_target_point
func set_target_point(new_point: Vector2):
  target_point = new_point
  emit_signal("target_point_set")


func shoot():
  if disabled:
    return
  
  emit_signal("shot")











