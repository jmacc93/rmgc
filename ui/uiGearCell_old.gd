extends Control

var composite

@export var gear_node : Node

@export var highlighted_color : Color
@export var non_highlighted_color : Color
var highlighted = false

func _enter_tree():
  print('gear_node set', gear_node)
  if gear_node == null:
    push_error('Invalid Node ', gear_node)
    queue_free()
    return
  
  composite = Lib.get_parent_with_method(gear_node, 'new_getter')
  if composite == null:
    push_error('No composite parent node for given node')
    queue_free()
    return
  
  gear_node.connect('tree_exiting', func():
    queue_free() #remove self when gear node is removed
  )
  
  highlighted = gear_node.get_meta('ui_cell_highlight', false)
  $background.color = highlighted_color if highlighted else non_highlighted_color
  Watch.call_on_set_meta(gear_node, 'ui_cell_highlight', func():
    highlighted = not highlighted
    $background.color = highlighted_color if highlighted else non_highlighted_color
  )
  
  var display_texture = find_ui_display_texture(gear_node)
  $TextureRect.texture = display_texture
  
  self.connect('gui_input', Callable(self, 'on_gui_input'))


func find_ui_display_texture(node: Node) -> Texture2D:
  var resource = node.get_meta('ui_cell_display')
  if (resource != null) and (resource is Texture2D):
    return resource
  else:
    return null


func on_gui_input(input: InputEvent):
  if not ((input is InputEventMouseButton) and input.pressed):
    return
  prints('pressed')
  
  var mouse_button_name = ''
  match input.button_index:
    MOUSE_BUTTON_LEFT: mouse_button_name = 'left_click'
    MOUSE_BUTTON_RIGHT: mouse_button_name = 'right_click'
    MOUSE_BUTTON_MIDDLE: mouse_button_name = 'middle_click'
  
  var metadata_prop_name = 'ui_cell_' + mouse_button_name
  var use_method = gear_node.get_meta(metadata_prop_name)
  if use_method == null:
    return
  
  if gear_node.has_method(use_method):
    gear_node.call(use_method, composite)
  elif gear_node.has_method('run_method') and gear_node.run_method(use_method, [composite]):
    return
  else:
    push_error('ability method ', use_method,' uncallable')
    return #not method called

















