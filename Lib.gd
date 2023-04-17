extends Node


#Parent-related functions ###############################
#########################################################

#The following get_parent_... all are mostly self describing
#The each get the closest parent (as in fewest get_parent calls to go from start_node to that parent)
# with the respective attribute

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

#Get the first parent with the given metadata property
func get_parent_with_meta(start_node: Node, meta_name: String):
  var current_node = start_node.get_parent()
  while current_node:
    if current_node.has_meta(meta_name):
      return current_node
    else:
      current_node = current_node.get_parent()
  return null

#Get the first parent with the given meta property that also has the given metadata value
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


func get_parent_in_group(start_node: Node, group_name: String):
  var current_node = start_node.get_parent()
  while current_node:
    if current_node.is_in_group(group_name):
      return current_node
    else:
      current_node = current_node.get_parent()
  return null

#Returns start_node's parent's parent or null
func get_grandparent(start_node: Node) -> Node:
  var parent = start_node.get_parent()
  if parent == null:
    return null
  return parent.get_parent()


#Child-related functions ################################
#########################################################

func is_child_of(possible_parent: Node, possible_child: Node):
  var current_node = possible_child.get_parent()
  while current_node:
    if current_node == possible_parent:
      return true
    else:
      current_node = current_node.get_parent()
  return false


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


func get_immediate_children_with_class(start_node: Node, classname: String):
  var ret = []
  for child in start_node.get_children():
    if child.get_class() == classname:
      ret.push_back(child)
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



#Metadata notifications helper functions#################
#########################################################

func callables_are_equals(callable1: Callable, callable2: Callable) -> bool:
  if callable1.get_object() != callable2.get_object():
    return false
  if callable1.get_method() != callable2.get_method():
    return false
  if callable1.get_bound_arguments_count() != callable2.get_bound_arguments_count():
    return false
  if callable1.get_bound_arguments() != callable2.get_bound_arguments():
    return false
  return true


func add_callable_to_dict(dict: Dictionary, key: String, value: Callable) -> bool:
  var existing_callable_array = dict.get(key)
  if existing_callable_array:
    if existing_callable_array.has(value):
      return false
    else:
      existing_callable_array.push_back(value)
      return true
  else:
    var new_callable_array = [value]
    dict[key] = new_callable_array
    return true


func remove_callable_from_dict(dict: Dictionary, key: String, value: Callable) -> bool:
  var existing_callable_array: Array = dict.get(key)
  if existing_callable_array:
    for i in range(0, existing_callable_array.size()):
      var existing_callable = existing_callable_array[i]
      if callables_are_equals(value, existing_callable):
        existing_callable_array.remove_at(i)
        break
    return true
  else:
    return false


func call_callable(dict: Dictionary, signalers_name: String, args: Array):
  var callable_array = dict.get(signalers_name)
  if callable_array == null:
    return
  var i = callable_array.size()-1
  while i >= 0: #reverse interation so can delete elements
    var callable = callable_array[i]
    callable.callv(args)
    i -= 1



#Vector and random generation functions #################
#########################################################

#Vector that makes the given angle with the positive x axis going counter-clockwise: (cos q, sin q)
func cs_vec(angle: float):
  return Vector2(cos(angle), sin(angle))


#Picks a random vector from the rectangle [[-spread, spread], [-spread, spread]]
#ie: the x, y elements of the vector can be in [-spread, spread]
func rand_vec(spread: float):
  return Vector2(randf_range(-spread, spread), randf_range(-spread, spread))


#Picks a random vector spread binormally (in R^2) around (0, 0)
func rand_binormal_vec(spread: float, r: float = 2.0):
  assert(r > 0)
  var mag = spread * pow(-log(randf()), 1/r)
  var angle = randf() * 2 * PI
  return Vector2(mag * cos(angle), mag * sin(angle))


#Selects a random index using the given chance_list as an un-normalized list of probabilities
#[10, 5, 1] -> mostly index 0, about half that much index 1, almost no index 2
#input is unnormalized probability of the corresponding indecies being the one returned
#note: [10, 5, 1] is equivalent to [0.625, 0.3125, 0.0625] when normalized
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


#Selects a random element from array using equal probability for each of array's elements
func pick_random_from(array: Variant):
  if array.size() == 0:
    return null
  
  var index = randi_range(0, array.size()-1)
  return array[index]


#Loads a random .png, .jpg, etc as a Texture from the given directory
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


#Vector projection and vector rejection
#Projection of a onto b is the vector colinear with b that is closest to a (think of it like the shadow of a on b)
#Rejection of a onto b is the vector perpendicular to b that points from b to a
#note: vec_proj(a, b) + vec_rej(a, b) == a
func vec_proj(a: Vector2, b: Vector2):
  return b * a.dot(b) / b.dot(b)

func vec_rej(a: Vector2, b: Vector2):
  return a - vec_proj(a, b)



#Node / object helper functions #########################
#########################################################


#Object.get but with a default
func getprop(obj: Object, prop: String, def):
  return obj.get(prop) if (prop in obj) else def


#like obj.get_meta(prop) but _actually_ respects null values!
func get_object_meta(obj: Object, prop: String, default: Variant = null) -> Variant:
  if obj.has_meta(prop):
    return obj.get_meta(prop)
  else:
    return default


#synonym of get_object_meta
func getmeta(obj: Object, prop: String, default: Variant = null) -> Variant:
  return get_object_meta(obj, prop, default)


func is_disabled(node: Node):
  return (node.process_mode == PROCESS_MODE_DISABLED)


#Make a PackedScene for later instantiation from a node
#note: sets all node's childrens' owner to node
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



#Array element finding helper functions #################
#########################################################

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


#Calculates the finaly z_index of the given object by adding up parent z_indices
func total_z_index(obj: CanvasItem):
  var current_node = obj
  var z_index_sum = 0
  while current_node != null:
    if 'z_index' in current_node:
      z_index_sum += current_node.z_index
      if not current_node.z_as_relative:
        break #here, further parents don't affect obj's final z_index
    current_node = current_node.get_parent()
  return z_index_sum


#Querying colliders at global position ##################
#########################################################

@onready var query_point = PhysicsPointQueryParameters2D.new()
func query_colliders_at(point: Vector2):
  query_point.collide_with_areas = true
  query_point.position = point
  return player_character.get_viewport().world_2d.direct_space_state.intersect_point(query_point, 16)


func get_z_ordered_collider_query_at(point: Vector2):
  var query_results = query_colliders_at(point)
  query_results.sort_custom(func(a, b): return total_z_index(a.collider) > total_z_index(b.collider))
  return query_results



#Delayed calling ########################################
#########################################################

var call_after_list = []
var new_call_after_items = [] #<- this is a buffer for new call_after functions
#if we didn't have this buffer, then we couldn't add new functions to call_after_list
#while we are processing call_after_list items. ie: We couldn't add new
#call_after functions inside a call_after_list item function

#Call the given function fn after a delay of approximately delay_ms
func call_after(delay_ms: int, fn: Callable):
  new_call_after_items.push_back([fn, delay_ms])


#add delayed functions buffed in new_call_after_items to call_after_list in sorted order
func integrate_new_call_after_items():
  while new_call_after_items.size() > 0:
    var fn_time  = new_call_after_items.pop_back()
    var delay_ms = fn_time[1]
    #insert the given fn at the right position in call_after_list to keep it sorted by call time
    var current_time = Time.get_ticks_msec()
    var call_time = current_time + delay_ms
    var i = call_after_list.size()-1
    while i >= 0:
      var fn_and_time = call_after_list[i]
      if fn_and_time[1] > call_time:
        call_after_list.insert(i+1, fn_time)
        return
      i -= 1
    #else, no return called so didnt insert
    call_after_list.push_front(fn_time)


#Call functions registered to be called after a delay
func process_call_after_list():
  #call_after_list is sorted by call time
  #This loop goes from the end of the call_after_list towards the front,
  #calling every element it goes over, and stopping if an element's call time is greater than current time
  var i = call_after_list.size()-1
  while i >= 0:
    var fn_and_time = call_after_list[i]
    var fn          = fn_and_time[0] as Callable
    var call_time   = fn_and_time[1]
    var current_time = Time.get_ticks_msec()
    if call_time > current_time:
      return
    fn.call()
    call_after_list.remove_at(i)
    i -= 1


#_init, _input, _process ################################
#########################################################

#The following is for mouse clicking on arbitrary CollisionObject2Ds and mouse dragging functionality

#The main points to take away from this section:
#  * All clickable CollisionObject2Ds (eg: Area2Ds) can be clicked, dragged
#  * The topmost (highest z_index) objects are clicked, dragged, etc if there is overlap between multiple objects
#  * On mouse events, their on_direct_mouse_event method / callable property is called if they have one
#  * When mouse is down and moved a little, own_dragging_started method / callable property is called on the object
#  * When mouse is up, own_dragging_ended method / callable property is called on the object the mouse originally went down on
#  * Also, on mouse up, dragging_ended method / callable property is called on the object the mouse is currently over

#dragged_data: can be set in own_dragging_started functions
#player_character: must be set for the the drag-drop and on_direct_mouse_event system to work
#mouse_is_down: for checking distance from mouse down point to current mouse point to set is_dragging to true
#drag_originator: which object the mouse initially went down on to start dragging
#is_dragging: dragging is engaged; own_dragging_started, etc drag functions will be called
# drag_engage_distance: distance mouse must move after mouse down before is_dragging = true and drag functions called
#dragging_display: what is shown at the mouse when dragging, set dragging_display.texture = ... in own_dragging_started functions

var dragged_data: Variant = null
var player_character : CanvasItem = null
var mouse_is_down = false
var mouse_button_down = MOUSE_BUTTON_LEFT
var mouse_down_point = Vector2(0, 0)
var drag_originator : CollisionObject2D = null
var is_dragging = false
var drag_engage_distance = 4 #pixels
@onready var dragging_display = Sprite2D.new()

#Handle clicks for dragging and calling on_direct_mouse_event methods on CollisionObject2Ds
func _input(event: InputEvent):
  if player_character == null:
    return #player_character must be set for _input function to get the mouse position in the right world
  if not (event is InputEventMouse):
    return
  
  #get the highest z_index pickable CollisionObject2Ds under the mouse and send the mouse event to it:
  
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
  
  #Set the dragging mode:
  
  if event is InputEventMouseButton:
    if event.pressed:
      if not is_dragging: #not already dragging
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
      mouse_button_down = -1
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

#Update dragging display, call delayed functions
func _process(_delta: float):
  if is_dragging:
    dragging_display.global_position = player_character.get_global_mouse_position()
  
  #call delayed functions, and accumulate new delayed functions
  if call_after_list.size() > 0:
    process_call_after_list()
  
  #add accumulated delayed functions into process_call_after_list:
  if new_call_after_items.size() > 0:
    integrate_new_call_after_items()
      





