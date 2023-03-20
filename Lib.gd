extends Node

func get_parent_with_class(start_node: Node, class_type : String):
  var current_node = start_node.get_parent()
  while current_node:
    if current_node.is_class(class_type):
      return current_node
    else:
      current_node = current_node.get_parent()
  return null


func get_parent_with_property(start_node: Node, property_name: String):
  var current_node = start_node.get_parent()
  while current_node:
    if property_name in current_node:
      return current_node
    else:
      current_node = current_node.get_parent()
  return null


func get_parent_with_property_value(start_node: Node, property_name: String, property_value):
  var current_node = start_node.get_parent()
  while current_node:
    if (property_name in current_node) and (current_node.get(property_name) == property_value):
      return current_node
    else:
      current_node = current_node.get_parent()
  return null


func get_parent_with_meta(start_node: Node, meta_name: String):
  var current_node = start_node.get_parent()
  while current_node:
    prints('current node', current_node, 'has meta?', current_node.has_meta(meta_name))
    if current_node.has_meta(meta_name):
      return current_node
    else:
      current_node = current_node.get_parent()
  return null


func get_parent_with_meta_value(start_node: Node, meta_name: String, meta_value):
  var current_node = start_node.get_parent()
  while current_node:
    if current_node.has_meta(meta_name) and (current_node.get_meta(meta_name) == meta_value):
      return current_node
    else:
      current_node = current_node.get_parent()
  return null


func get_parent_with_signal(start_node: Node, signal_name: String):
  var current_node = start_node.get_parent()
  while current_node:
    if current_node.has_signal(signal_name):
      return current_node
    else:
      current_node = current_node.get_parent()
  return null


func get_parent_with_method(start_node: Node, method_name: String):
  var current_node = start_node.get_parent()
  while current_node:
    if current_node.has_method(method_name):
      return current_node
    else:
      current_node = current_node.get_parent()
  return null


func get_parent_in_group(start_node: Node, group_name: String):
  var current_node = start_node.get_parent()
  while current_node:
    if current_node.is_in_group(group_name):
      return current_node
    else:
      current_node = current_node.get_parent()
  return null



func get_children_in_group(start_node: Node, group_name: String, max_depth: float = 1):
  var nodes_to_search = []
  var ret = []
  for i in range(0, start_node.get_child_count()):
    var child = start_node.get_child(i)
    nodes_to_search.push_back([child, 1])
  while nodes_to_search.size() > 0:
    var current_node_and_depth = nodes_to_search.pop_front()
    var current_node = current_node_and_depth[0]
    var nodes_depth  = current_node_and_depth[1]
    if current_node.is_in_group(group_name):
      ret.push_back(current_node)
    if (nodes_depth < max_depth) or (max_depth == -1):
      for i in range(0, current_node.get_child_count()):
        var child = current_node.get_child(i)
        nodes_to_search.push_back([child, nodes_depth + 1])
  return ret



func cs_vec(angle: float):
  return Vector2(cos(angle), sin(angle))


func rand_vec(spread: float):
  return Vector2(randf_range(-spread, spread), randf_range(-spread, spread))


func vec_proj(a: Vector2, b: Vector2):
  return b * a.dot(b) / b.dot(b)

func vec_rej(a: Vector2, b: Vector2):
  return a - vec_proj(a, b)


func getprop(obj: Object, prop: String, def):
  return obj.get(prop) if (prop in obj) else def

var meta_notifier : Node
func _init():
  meta_notifier = Node.new()
  meta_notifier.add_user_signal('set')


func get_object_meta(obj: Object, prop: String, default: Variant = null) -> Variant:
  if obj.has_meta(prop):
    return obj.get_meta(prop)
  else:
    return default












