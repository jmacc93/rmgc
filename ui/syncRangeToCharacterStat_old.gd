extends Node

#The hp / mp / etc of the closest parent in the character group is synced to the closest Range / ProgressBar / TexturedProgressBar / etc parent

var range_parent : Range

var character : Node
@export var stat = 'hp'
@export var max_stat_name = ''
@export var max_stat_value : float

var update_by_poll = false
var next_stat_poll_time = 0
@export var stat_polling_period = 200 #ms


func _ready():
  range_parent = Lib.get_parent_with_class(self, 'Range')
  if not range_parent:
    push_error('No Range, ProgressBar, etc parent found')
    return
    
  character = Lib.get_parent_in_group(self, 'character')
  if not character:
    push_error('No character found')
    return
  
  set_process(false)
  if character.has_signal('stat_changed'):
    character.connect('stat_changed', Callable(self, 'on_stat_changed'))
  elif stat == 'hp' and character.has_signal('hurt'):
    character.connect('hurt', Callable(self, 'on_hurt'))
  else:
    update_by_poll = true
    set_process(true)


func on_hurt(dmg, dmger):
  on_stat_changed('hp', character.hp - dmg, dmger)

func on_stat_changed(changed_stat: String, _prev_value, _changer_object):
  if changed_stat != stat:
    return
  range_parent.max_value = character.get(max_stat_name) if (max_stat_name != '') else max_stat_value
  range_parent.value = character.get(stat)


func _process(_delta):
  if not update_by_poll:
    return

  var current_time = Time.get_ticks_msec()
  if next_stat_poll_time > current_time:
    return

  next_stat_poll_time = current_time + stat_polling_period
