extends Node

@export var max_hp = 100.0
@export var hp = 100.0
@export var hp_regen = 1.0 #hp / second

@export var mdef = 1.0 #multiplicative defence, divides damage taken
@export var adef = 0.0 #additive defence, subtracts from damage taken up to 0

var composite

func _enter_tree():
  composite = Lib.get_parent_with_method(self, "new_getter")
  if not composite:
    push_error('No parent composite found')
    return
  composite.new_getters(['hp', 'health'], Callable(self, 'get_hp'))
  composite.new_setters(['hp', 'health'], Callable(self, 'set_hp'))
  composite.new_getters(['max_hp', 'max_health'], Callable(self, 'get_max_hp'))
  composite.new_setters(['max_hp', 'max_health'], Callable(self, 'set_max_hp'))
  composite.new_getters(['hp_regen', 'health_regen'], Callable(self, 'get_hp_regen'))
  composite.new_setters(['hp_regen', 'health_regen'], Callable(self, 'set_hp_regen'))


func _ready():
  composite.set_prop('hp', hp)
  composite.set_prop('max_hp', max_hp)
  composite.set_prop('hp_regen', hp_regen)


func get_hp():
  return hp
func set_hp(new_hp):
  hp = new_hp
  
func get_max_hp():
  return max_hp
func set_max_hp(new_max_hp):
  max_hp = new_max_hp
  
func get_hp_regen():
  return hp_regen
func set_hp_regen(new_hp_regen):
  hp_regen = new_hp_regen
