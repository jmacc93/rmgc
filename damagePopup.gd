extends Node2D

@onready var label : Label = get_node("Label")
@onready var initial_label_position = label.position

var damage_amount : int = 0

@export var lifespan_msec = 750
@onready var timeout_time = Time.get_ticks_msec() + lifespan_msec

@export var float_distance = 5.0
@onready var float_speed : float = 1000 * float_distance / lifespan_msec

func _ready():
  label = get_node("Label")
  assert(label)

func set_damage(new_damage):
  if not label:
    label = get_node("Label")
    assert(label)
  damage_amount = int(ceil(new_damage))
  label.text = str(damage_amount)

func _process(delta):
  var current_time = Time.get_ticks_msec()
  if current_time > timeout_time:
    queue_free()
    return
  
  label.position += Vector2(0, - float_speed * delta)
