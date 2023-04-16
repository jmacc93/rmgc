extends Node2D

var damage_amount : int = 0

@export var lifespan_msec = 750
@onready var timeout_time = Time.get_ticks_msec() + lifespan_msec

@export var float_distance = 5.0
@onready var float_speed : float = 1000 * float_distance / lifespan_msec

func set_damage(new_damage):
  var label = $Label
  damage_amount = int(ceil(new_damage))
  if new_damage > 0:
    label.text = '+' + str(damage_amount)
    label.modulate = Color.LIGHT_GREEN
  else:
    label.text = str(damage_amount)
    label.modulate = Color.LIGHT_CORAL

func _process(delta):
  var current_time = Time.get_ticks_msec()
  if current_time > timeout_time:
    queue_free()
    return
  
  $Label.position += Vector2(0, - float_speed * delta)
