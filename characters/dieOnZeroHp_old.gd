extends Node

#@onready var hurtable: Object
#
#func _ready():
#  hurtable = Lib.get_parent_with_signal(self, "hurt")
#  if not hurtable:
#    push_error("No hurtable parent found")
#    return
#  hurtable.connect("hurt", Callable(self, "on_hurt"))
#
#func on_hurt(_dmg: float, _dmger: Object):
#  if not ('hp' in hurtable):
#    return
#
#  if hurtable.hp > 0:
#    return
#
#  if 'should_die' in hurtable:
#    hurtable.should_die = true
#  if hurtable.has_signal('killed'):
#    hurtable.emit_signal("killed", dmger)
#  if Lib.getprop(hurtable, 'should_die', false):
#    hurtable.queue_free()
