extends Node

var composite

var timeout_time
@export var max_age = 1.0

func _enter_tree():
  composite = Lib.get_parent_with_method(self, "new_getter")
  if not composite:
    push_error('No composite parent found')
    queue_free()
    return
  
  timeout_time = Time.get_ticks_msec() + max_age * 1000
  

func _process(_delta):
  var current_time = Time.get_ticks_msec()
  if (timeout_time < current_time):
    if not composite.run_first_method_in(['kill', 'destroy'], []):
      composite.queue_free()
