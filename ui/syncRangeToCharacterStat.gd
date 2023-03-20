extends Node

#The hp / mp / etc of the closest parent in the character group is synced to the closest Range / ProgressBar / TexturedProgressBar / etc parent

var range_parent : Range

var composite : Node

@export var stat = 'hp'
@export var max_stat = ''


func _enter_tree():
  composite = Lib.get_parent_with_method(self, 'new_getter')
  if composite == null:
    push_error("No parent composite found")
    queue_free()
    return
  
  range_parent = Lib.get_parent_with_class(self, 'Range')
  if range_parent == null:
    push_error('No Range, ProgressBar, etc parent found')
    queue_free()
    return
  
  composite.call_on_set(stat, Callable(self, 'on_stat_change'))
  if max_stat != '':
    composite.call_on_set(max_stat, Callable(self, 'on_max_stat_change'))


func _ready():
  #set initial values on next idle  
  (func():
    on_stat_change(composite.get_prop(stat))
    if max_stat != '':
      on_max_stat_change(composite.get_prop(max_stat))
  ).call_deferred()


func on_stat_change(new_stat_value):
  if new_stat_value is float:
    range_parent.set_value(new_stat_value)

func on_max_stat_change(new_max_stat_value):
  if new_max_stat_value is float:
    range_parent.set_max(new_max_stat_value)

