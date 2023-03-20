extends Label

@export var font_resource : Font

func _init():
  add_theme_font_override("normal_font", font_resource)
#  font = font_resource
