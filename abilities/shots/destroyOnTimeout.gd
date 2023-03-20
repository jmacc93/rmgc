extends Node

var parent
var timeout_time
@export var max_age = 1.0

func _ready():
  parent = get_parent()
  if parent:
    timeout_time = Time.get_ticks_msec() + max_age * 1000
  else:
    queue_free()

func _process(_delta):
  if (timeout_time < Time.get_ticks_msec()):
    parent.queue_free()
