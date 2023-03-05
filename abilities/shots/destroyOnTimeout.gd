extends Node

var shot : Shot
var timeout_time
export var max_age = 1.0

func _ready():
  shot = Lib.get_parent_with_class(self, Shot)
  if shot:
    timeout_time = OS.get_ticks_msec() + max_age * 1000
  else:
    queue_free()

func _process(delta):
  if (timeout_time < OS.get_ticks_msec()):
    shot.queue_free()
