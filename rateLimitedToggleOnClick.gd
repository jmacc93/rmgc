extends Node

var parent_togglable

@export var cooldown_time = 0.0
var next_pressable_time : int

func _ready():
  parent_togglable = Lib.get_parent_with_signal(self, 'toggled')
  if not parent_togglable:
    push_error('No parent with toggled signal found')
    return
  
  cooldown_time = abs(cooldown_time)

func _input(event: InputEvent):
  if (event is InputEventMouseButton) and (event.button_index == MOUSE_BUTTON_LEFT):
    pass

#func _toggled(pressed_state):
#  var current_time = Time.get_ticks_msec()
#  if current_time > next_pressable_time:
##    emit_signal('toggled', pressed_state)
#    next_pressable_time = current_time + int(1000 * cooldown_time)
