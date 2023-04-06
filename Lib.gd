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


func get_parent_with_name(start_node: Node, name_string: String):
  var current_node = start_node.get_parent()
  while current_node:
    if current_node.name == name_string:
      return current_node
    else:
      current_node = current_node.get_parent()
  return null


func is_child_of(possible_parent: Node, possible_child: Node):
  var current_node = possible_child.get_parent()
  while current_node:
    if current_node == possible_parent:
      return true
    else:
      current_node = current_node.get_parent()
  return false


func is_disabled(node: Node):
  return (node.process_mode == PROCESS_MODE_DISABLED)


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


func get_first_immediate_child_in_group(start_node: Node, group_name: String):
  for child in start_node.get_children():
    if child.is_in_group(group_name):
      return child
  return null


func get_first_immediate_child_with_class(start_node: Node, classname: String):
  for child in start_node.get_children():
    if child.get_class() == classname:
      return child
  return null



func get_first_immediate_child_texture(start_node: Node) -> Texture2D:
  for child in start_node.get_children():
    if 'texture' in child:
      return child.texture
  return null


func cs_vec(angle: float):
  return Vector2(cos(angle), sin(angle))


func rand_vec(spread: float):
  return Vector2(randf_range(-spread, spread), randf_range(-spread, spread))


func rand_binormal_vec(spread: float, r: float = 2.0):
  assert(r > 0)
  var mag = spread * pow(-log(randf()), 1/r)
  var angle = randf() * 2 * PI
  return Vector2(mag * cos(angle), mag * sin(angle))


#[10, 5, 1] -> mostly index 0, about half that much index 1, almost no index 2
#input is unnormalized probability of the corresponding indecies being the one returned
func random_index_with_probs(chance_list: Array):
  if chance_list.size() == 0:
    return null
  
  var chance_sum = 0.0
  for chance in chance_list:
    chance_sum += chance
  
  if chance_sum == 0:
    return null
  
  var total_prob = 0.0
  var selection_prob = randf()
  for i in range(0, chance_list.size()):
    total_prob += chance_list[i] / chance_sum
    if selection_prob <= total_prob:
      return i
  
  return chance_list.size()


func pick_random_from(array: Variant):
  if array.size() == 0:
    return null
  
  var index = randi_range(0, array.size()-1)
  return array[index]


func random_texture2d_from(directory: String):
  if directory == '':
    push_error('No directory given')
    return
  
  var dir_access = DirAccess.open(directory)
  var file_list = []
  for possible_file in dir_access.get_files():
    if possible_file.ends_with('png') or possible_file.ends_with('jpg') or possible_file.ends_with('jpeg'):
      file_list.push_back(possible_file)
  var file = Lib.pick_random_from(file_list)
  if file == null:
    push_error('No files found to select from')
    return
  
  return load(directory + '/' + file)


func vec_proj(a: Vector2, b: Vector2):
  return b * a.dot(b) / b.dot(b)

func vec_rej(a: Vector2, b: Vector2):
  return a - vec_proj(a, b)


func getprop(obj: Object, prop: String, def):
  return obj.get(prop) if (prop in obj) else def


func make_scene_from_node(node: Node):
  var child_stack = [node]
  while child_stack.size() > 0:
    var top = child_stack.pop_back()
    if top != node:
      top.set_owner(node)
    for child in top.get_children():
      child_stack.push_back(child)
  
  var scene = PackedScene.new()
  scene.resource_local_to_scene = true
  scene.pack(node)
  return scene


#func add_node_as_child(parent: Node, child: Node):
#  Comp.


var meta_notifier : Node
func _init():
  process_priority = -2048

  meta_notifier = Node.new()
  meta_notifier.add_user_signal('set')


func get_object_meta(obj: Object, prop: String, default: Variant = null) -> Variant:
  if obj.has_meta(prop):
    return obj.get_meta(prop)
  else:
    return default

#synonym of get_object_meta
func getmeta(obj: Object, prop: String, default: Variant = null) -> Variant:
  return get_object_meta(obj, prop, default)


func get_first_index_satisfying(array: Array, predicate: Callable) -> Variant:
  for i in range(0, array.size()):
    var value = array[i]
    if predicate.call(value):
      return i
  return -1
  
func get_first_nonnull_return(array: Array, fn: Callable) -> Variant:
  for i in range(0, array.size()):
    var value = array[i]
    var res = fn.call(value)
    if res != null:
      return res
  return null


#the total z_index of an object, accounting for parent z_index and z_as_relative status
func total_z_index(obj: CanvasItem):
  var current_node = obj
  var z_index_sum = 0
  while current_node != null:
    if 'z_index' in current_node:
      if current_node.z_as_relative:
        z_index_sum += current_node.z_index
      else:
        z_index_sum = current_node.z_index
    current_node = current_node.get_parent()
  return z_index_sum


var dragged_data: Variant = null


@onready var query_point = PhysicsPointQueryParameters2D.new()
func query_colliders_at(point: Vector2):
  query_point.collide_with_areas = true
  query_point.position = point
  return player_character.get_viewport().world_2d.direct_space_state.intersect_point(query_point, 16)


func get_z_ordered_collider_query_at(point: Vector2):
  var query_results = query_colliders_at(point)
  query_results.sort_custom(func(a, b): return total_z_index(a.collider) > total_z_index(b.collider))
  return query_results


#get the highest z_index pickable CollisionObject2Ds under the mouse and send the mouse event to it 
var player_character : CanvasItem = null
var mouse_is_down = false
var mouse_button_down = MOUSE_BUTTON_LEFT
var mouse_down_point = Vector2(0, 0)
var drag_originator : CollisionObject2D = null
var is_dragging = false
var drag_engage_distance = 4 #pixels
@onready var dragging_display = Sprite2D.new()
func _input(event: InputEvent):
  if player_character == null:
    return
  if not (event is InputEventMouse):
    return
  
  var current_mouse_position = player_character.get_global_mouse_position()
  var query_results = query_colliders_at(current_mouse_position)
  
  #get topmost mouse collider with on_direct_mouse_event method
  var max_z_index: int
  var max_z_fn: Variant = null
  var max_z_collider : CollisionObject2D = null
  for result_dict in query_results:
    
    var collider = result_dict.collider
    var collider_z_index = total_z_index(collider)
    if (collider_z_index < max_z_index) and (max_z_fn != null):
      continue
    
    var new_max_fn
    if collider.has_method('on_direct_mouse_event'):
      new_max_fn = collider.on_direct_mouse_event
    elif collider.has_meta('on_direct_mouse_event'):
      var meta_value = collider.get_meta('on_direct_mouse_event')
      if meta_value is String:
        new_max_fn = collider.get_meta(meta_value)
      elif meta_value is Callable:
        new_max_fn = meta_value
    
    if new_max_fn != null:
      max_z_fn = new_max_fn
      max_z_index = total_z_index(collider)
      max_z_collider = collider
  
  #call topmost collider object
  if max_z_fn != null:
    max_z_fn.call(event)
  
  #set dragging mode
  if event is InputEventMouseButton:
    if event.pressed:
      if not is_dragging:
        #set mouse down status to start dragging
        mouse_is_down = true
        mouse_down_point = current_mouse_position
        mouse_button_down = event.button_index
        if max_z_collider != null:
          drag_originator = max_z_collider

    elif mouse_button_down == event.button_index:
      #dragged button is released
      if is_dragging:
        Comp.run_method(drag_originator, 'own_dragging_ended', [max_z_collider])
        if max_z_collider != null:
          Comp.run_method(max_z_collider, 'dragging_ended')
      is_dragging = false
      mouse_is_down = false
      dragged_data = null
      dragging_display.texture = null
      drag_originator = null
  
  elif event is InputEventMouseMotion:
    if is_dragging:
      pass

    elif mouse_is_down:
      var has_drag_originator = (drag_originator != null)
      var far_from_start_of_drag = (current_mouse_position - mouse_down_point).length() > drag_engage_distance
      if has_drag_originator and far_from_start_of_drag :
        #begin dragging
        is_dragging = true
        if (player_character != null):
          var viewport = player_character.get_viewport()
          if dragging_display.get_parent() == null:
            viewport.add_child(dragging_display)
          else:
            dragging_display.reparent(viewport)
          dragging_display.z_index = 2048
        Comp.run_method(drag_originator, 'own_dragging_started')


func _process(_delta: float):
  if is_dragging:
    dragging_display.global_position = player_character.get_global_mouse_position()
      





