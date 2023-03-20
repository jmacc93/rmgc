extends Node

var parent_button

@export var cooldown_time = 0.0
var reenable_time : int

var is_disabled = false

func _ready():
  parent_button = Lib.get_parent_with_class(self, 'BaseButton')
  if not parent_button:
    push_error('No BaseButton found')
    return
  
  cooldown_time = abs(cooldown_time)
  
  set_process(false)
  parent_button.connect('pressed', Callable(self, 'disable'))

func disable():
  var current_time = Time.get_ticks_msec()
  reenable_time = current_time + int(cooldown_time * 1000.0)
  parent_button.disabled = true
  is_disabled = true
  set_process(true)

func _process(delta):
  if not is_disabled:
    set_process(false)
    return
  var current_time = Time.get_ticks_msec()
  if current_time > reenable_time:
    parent_button.disabled = false
    is_disabled = false
    set_process(false)
