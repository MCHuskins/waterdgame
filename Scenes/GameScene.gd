extends Node2D

var map_node

var build_mode = false
var build_valid = false
var build_location 
var bulid_type

func _ready():
	map_node = get_node("Map 1")
	
	for i in get_tree().get_nodes_in_group('bb'):
		i.connect("pressed",self,"initiate_build_mode",[i.get_name()])

func _process(delta):
	pass

func _unhandled_input(event):
	pass

func initiate_build_mode(tower_type):
	bulid_type = tower_type + "t1"

func update_tower_preview():
	pass 

func cancel_build_mode():
	pass

func varlify_and_build():
	pass
