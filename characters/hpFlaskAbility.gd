extends Node

var composite

@export var health = 25

func use_flask(user: Object):
  print('use_flask on ', user)
  if user.has_method('new_getter'): #is a composite
    user.call_method('heal_by', [health])
  elif user.has_method('heal_by'):
    user.heal_by(25)
  print('freeing flask')
  composite.queue_free()