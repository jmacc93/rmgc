extends Node



var default_loot_bag: PackedScene = preload("res://items/basicLootBag.tscn")


func get_game_world(node: Node):
  return Lib.get_parent_in_group(node, 'game_world')


func check_factions_agree(obj1: Object, obj2: Object) -> bool:
  #check via methods
  #check via faction_array
  #check via faction_object
  return true


