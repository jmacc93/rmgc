extends Node



var default_loot_bag: PackedScene = preload("res://environment/loot_containers/basicLootBag.tscn")


func get_game_world(node: Node):
  return Lib.get_parent_in_group(node, 'game_world')



var standard_faction_alignment = {
  "players": {
    "players": true,
    "enemies": false,
    "default": true
  },
  "enemies": {
    "players": false,
    "enemies": true,
    "default": true
  },
  "default": {
    "default": true
  }
}


#the asymmetric version of check_faction_agree
func check_faction_agrees_with_another(faction1: String, faction2: String) -> bool:
  #get 1's alignment dictionary, or get default alignment dict
  var faction1_alignment_dict = standard_faction_alignment.get(faction1, null)
  if faction1_alignment_dict == null:
    faction1_alignment_dict = standard_faction_alignment.get('default')
  
  #get dictionary's alignment value for 2, or get default in that dictionary
  var faction1_alignment_with_2 = faction1_alignment_dict.get(faction2)
  if faction1_alignment_with_2 == null:
    faction1_alignment_with_2 = faction1_alignment_dict.get('default')
  
  return faction1_alignment_with_2


#this makes the check between faction1 and faction2 commutative (so even if
#standard_faction_alignment's entries aren't symmetric, this makes it symmetric)
func check_faction_strings_agree(faction1: String, faction2: String) -> bool:
  var alignment_of_1_with_2 = check_faction_agrees_with_another(faction1, faction2)
  var alignment_of_2_with_1 = check_faction_agrees_with_another(faction2, faction1)
  return alignment_of_1_with_2 and alignment_of_2_with_1


func normalize_faction_object(obj) -> Array:
  if obj is Array:
    return obj
  elif obj is String:
    return obj.split(',')
  else:
    return []


#obj1 and obj2 can be strings (w/ commas for separation), arrays of strings, or functions
#if either obj is a function, then that function is deferred to to check agreement
func check_factions_agree(obj1: Variant, obj2: Variant) -> bool:
  if obj1 is Callable:
    var ret = obj1.call(obj2)
    return ret if (ret != null) else true
  elif obj2 is Callable:
    var ret = obj2.call(obj1)
    return ret if (ret != null) else true
  
  var factions_array1: Array = normalize_faction_object(obj1)
  var factions_array2: Array = normalize_faction_object(obj2)
  
  var ret = true
  for faction1 in factions_array1:
    for faction2 in factions_array2:
      var alignment = check_faction_strings_agree(faction1, faction2)
      ret = ret and alignment
      if ret == false:
        return false #short circuit the loop
  return ret


