extends Node

@export var disabled = false

@export var count = 2

@export_flags('Signals', 'Groups', 'Scripts', 'Instantiation') var duplication_flags: int = DUPLICATE_USE_INSTANTIATION



func _ready():
  if disabled:
    return
  
  var parent_to_duplicate = get_parent()
  var grandparent_target = parent_to_duplicate.get_parent()
  if not (parent_to_duplicate and grandparent_target):
    push_error("parent or grandparent not found ", parent_to_duplicate, " ", grandparent_target)
  
  parent_to_duplicate.remove_child.call_deferred(self)
  for i in range(0, count):
    var new_child = parent_to_duplicate.duplicate(duplication_flags)
    grandparent_target.add_child.call_deferred(new_child)
  if grandparent_target.has_method('queue_sort'):
    grandparent_target.queue_sort()
