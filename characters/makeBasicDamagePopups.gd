extends Node2D

var composite

var damage_popup_resource : PackedScene = preload("res://damagePopup.tscn")


func _enter_tree():
  composite = Lib.get_parent_with_method(self, "new_getter")
  if not composite:
    push_error('No composite parent found')
    return
  
  composite.call_on("hurt", Callable(self, "on_hurt"))


func on_hurt(dmg: float, _damager: Object):
  var damage_popup = damage_popup_resource.instantiate()
  damage_popup.set_damage(dmg)
  add_child(damage_popup)


