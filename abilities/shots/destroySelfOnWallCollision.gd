extends Node

var composite

@export var wall_bit = 1

@export var except_parent = false

## restrict to a particular group, or leave blank to not restrict to a group
@export var group = ''

func _enter_tree():
  composite = Lib.get_parent_with_method(self, "new_getter")
  if not composite:
    push_error('No composite parent found')
    return
  
  composite.call_on('collision', Callable(self, 'on_collision'))


func on_collision(collision):
  if not collision:
    return
  
  var body = collision.get_collider()
  var parent_object = composite.get_prop('parent_object')
  
  #body has collision layer
  if not body.has_method('get_collision_layer_value'):
    return
  
  #only destroy self on collision with particular group?
  if (group != '') and (not body.is_in_group(group)):
    return
  
  #body in collision layer?
  if not body.get_collision_layer_value(wall_bit):
    return
  
  #is body the parent?
  if except_parent and parent_object and (body == parent_object):
    return
  
  #kill self
  if not composite.run_first_method_in(['kill', 'destroy'], []):
    composite.queue_free()












