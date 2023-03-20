extends Node

var composite

func _enter_tree():
  composite = Lib.get_parent_with_method(self, "new_getter")
  if not composite:
    push_error('No composite parent found')
    return

func _physics_process(_delta):
  if not composite:
    return
  
  var movement_direction = Vector2(0, 0)
  var did_move = false
  if Input.is_action_pressed("move_left"):
    movement_direction += Vector2(-1, 0)
    did_move = true
  if Input.is_action_pressed("move_right"):
    movement_direction += Vector2(1, 0)
    did_move = true
  if Input.is_action_pressed("move_up"):
    movement_direction += Vector2(0, -1)
    did_move = true
  if Input.is_action_pressed("move_down"):
    movement_direction += Vector2(0, 1)
    did_move = true
  
  if did_move:
    composite.run_first_method_in(['walk_by', 'move_by'], [movement_direction.normalized()])
  
