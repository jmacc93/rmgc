extends Node

class_name TestClass

signal siga

# Called when the node enters the scene tree for the first time.
func _ready():
  add_user_signal("sigb")
