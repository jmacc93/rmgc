extends Node

static func get_parent_with_class(start_node, class_type, debug = false):
  var current_node = start_node.get_parent()
  if debug:
    print("get_parent_with_class ", current_node)
  while current_node:
    if current_node is class_type:
      return current_node
    else:
      current_node = current_node.get_parent()
    if debug:
      print("get_parent_with_class ", current_node)
  return null
