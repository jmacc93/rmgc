extends Node2D

@onready var character : Node2D = Lib.get_parent_with_signal(self, 'hurt')

var damage_popup_resource : PackedScene = preload("res://damagePopup.tscn")

func _ready():
  if not character:
    push_error("No parent with 'hurt' signal found", self)
    queue_free()
    return
  character.connect("hurt", Callable(self,"on_hurt"))

func on_hurt(dmg: float, _damager: Object):
  var damage_popup = damage_popup_resource.instantiate()
  damage_popup.set_damage(dmg)
  add_child(damage_popup)


