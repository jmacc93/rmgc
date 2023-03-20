extends Area2D

@export var hates_everyone = false

var composite

var target_object

func _enter_tree():
  composite = Lib.get_parent_with_method(self, 'new_getter')
  if not composite:
    push_error('No composite parent found')
    queue_free()
    return
  
  composite.new_getter('target_object', func():
    return target_object
  )
  composite.new_setter('target_object', func(new_target_object):
    target_object = new_target_object
  )


#does character love or hate obj?
func is_hostile_faction_array(my_faction_array, obj_faction_array):
  for my_faction in my_faction_array:
    #if any of parent my factions are in obj's faction_array then they're best buds
    var my_faction_in_object = (obj_faction_array.find(my_faction) != -1)
    if my_faction_in_object:
      return false #loves
  return true #hates


#is body an enemy? then target. Return true if targeted something
func test_and_switch_target_to_body(body):
  #body is a composite?
  if not body.has_method('get_prop'):
    return false
  
  #does body have a faction?
  var body_faction_array = body.get_prop('faction_array')
  if body_faction_array == null:
    if hates_everyone and body.is_in_group('character'):
      composite.set_prop('target_object', body)
      return true
    else:
      return false
  
  #do I have a faction?
  var my_faction_array = composite.get_prop('faction_array')
  if my_faction_array == null:
    return false
  
  #compare faction arrays
  var obj_is_enemy = is_hostile_faction_array(my_faction_array, body_faction_array)
  if obj_is_enemy:
    composite.set_prop('target_object', body)
    return true
  
  #no action taken
  return false
  


#target characters and factioned objects that enter
func _on_targetNearestNonfaction_body_entered(body):
  #dont do anything if already have target
  if target_object != null:
    return
  
  #set new target if body is hostile faction
  test_and_switch_target_to_body(body)


#untarget active target if its far away, and then get a new target if there are any
func _on_targetNearestNonfaction_body_exited(body):
  #dont untarget current target if it didnt just leave
  if body != target_object:
    return
  
  #get a new target, if there is one still in this area
  composite.set_prop('target_object', null)
  for overlapping_body in get_overlapping_bodies():
    var has_new_target = test_and_switch_target_to_body(overlapping_body)
    if has_new_target:
      return










