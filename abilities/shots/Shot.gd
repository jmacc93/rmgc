extends KinematicBody2D

class_name Shot

export var velocity := Vector2(0.0, 0.0)

var damage = 1.0

var type = "shot"

var parent_character : Character

var collision_handlers : Array

func add_collision_handler(node: Node):
  if not node.has_method('handle_collision'):
    return
  var index = collision_handlers.find(node)
  if index == -1:
    collision_handlers.push_back(node)

func remove_collision_handler(node: Node):
  var index = collision_handlers.find(node)
  if index == -1:
    return
  collision_handlers.remove(index)

func _physics_process(delta):

  var collision = move_and_collide(velocity * delta, true, true, true) #infinite_inertia, exclude_raycast_shapes, test_only
  if (not collision):
    global_position += velocity * delta
    return

  for handler in collision_handlers:
    handler.handle_collision(collision)

func apply_collision(collision: CollisionObject2D):
  var collider = collision.collider
  var pass_through : bool = (('shots_pass_through' in collider) and collider.shots_pass_through) or (('obstructs_shots' in collider) and collider.obstructs_shots)
  if pass_through:
    return
  global_position += collision.travel()
  velocity = collision.remainder










