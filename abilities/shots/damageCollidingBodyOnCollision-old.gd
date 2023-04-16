extends Node

var composite

@export var damage = 10.0

@export var hurt_parent = false

func _enter_tree():
  composite = Lib.get_parent_with_method(self, "new_getter")
  if not composite:
    push_error('No composite parent found')
    return
  composite.call_on('collision', Callable(self, 'on_collision'))
  
  composite.new_getters(['dmg', 'damage'], Callable(self, 'get_dmg'))
  composite.new_setters(['dmg', 'damage'], Callable(self, 'set_dmg'))


func _ready():
  composite.set_prop('dmg', damage)


func get_dmg():
  return damage
func set_dmg(new_dmg):
  damage = new_dmg


func on_collision(collision):
  if not collision:
    return
  var body = collision.get_collider()
  if not body.has_method('new_getter'): #not a composite
    return
  
  #hurt parent?
  var parent_object = composite.get_prop('parent_object')
  if parent_object and (parent_object == body) and (not hurt_parent):
    return #dont hurt parent
  
  #damage by method
  var dmg = composite.get_first_prop_in(['dmg', 'damage'])
  if body.run_first_method_in(["hurt_by", 'damage_by'], [dmg, composite]):
    body.notify('hurt', [dmg, composite])
    return
  
  #damage by method
  if Comp.run_method(body, "hurt_by", [dmg, composite]):
    return
  
  #damage by directly changing health
  var hp = body.get_first_prop_in(['hp', 'health'])
  if hp != null:
    body.set_first_prop_in(['hp', 'health'], hp - dmg)
    body.notify('hurt', [dmg, composite])    
