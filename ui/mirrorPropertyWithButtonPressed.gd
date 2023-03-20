extends Node

var button : BaseButton
@export var node_path : NodePath = ''
var node : Node

@export var property = ''

@export var reverse = false


func _ready():
  if property == '':
    push_error('No property given')
    return
    
  if node_path.is_empty():
    push_error('No node path given')
    return
  node = get_node(node_path)
  if not (property in node):
    push_error('Node ', node, ' has no property ', property)
    return
  
  button = Lib.get_parent_with_class(self, "BaseButton")
  if not button:
    push_error('No parent button found')
    return
  
  button.connect('toggled', Callable(self, 'on_toggled'))
  

func on_toggled(pressed):
  node.set(property, pressed if (not reverse) else (not pressed))
