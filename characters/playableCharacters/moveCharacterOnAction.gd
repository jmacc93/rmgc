extends Node

onready var character : Character = Lib.get_parent_with_class(self, Character)

func _physics_process(delta):
  
  var movement_direction = Vector2(0, 0)
  var did_move = false
  if character and Input.is_action_pressed("move_left"):
    movement_direction += Vector2(-1, 0)
    did_move = true
  if character and Input.is_action_pressed("move_right"):
    movement_direction += Vector2(1, 0)
    did_move = true
  if character and Input.is_action_pressed("move_up"):
    movement_direction += Vector2(0, -1)
    did_move = true
  if character and Input.is_action_pressed("move_down"):
    movement_direction += Vector2(0, 1)
    did_move = true
  
  if did_move:
    character.move_by(movement_direction.normalized())
  
