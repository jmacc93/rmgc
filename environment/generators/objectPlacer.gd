extends Node2D

#@export var random_seed = 1
#
#@export var choice_set # (Array, PackedScene)
#@export var count = 1
#
#@export var spread = 10.0
#
#func _ready():
#  if (count <= 0) or (choice_set.size() == 0):
#    return
#
#  seed(random_seed)
#  for i in range(0, count):
#    choice_set.shuffle()
#    var choice = choice_set[0]
#    var instance = choice.instantiate()
#    instance.global_position = global_position + Lib.rand_vec(spread)
#    add_child(instance)
#
