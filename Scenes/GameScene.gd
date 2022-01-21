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
	if build_mode:
		update_tower_preview()

func _unhandled_input(event):
	pass

func initiate_build_mode(tower_type):
	bulid_type = tower_type + "t1"
	build_mode = true
	get_node("UI").set_tower_preview(bulid_type, get_global_mouse_position())

func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var current_tile = map_node.get_node("notower").world_to_map(mouse_position)
	var tile_position = map_node.get_node("notower").map_to_world(current_tile)
	
	if map_node.get_node("notower").get_cellv(current_tile)==-1:
		get_node("UI").update_tower_preview(tile_position,"ad54ff3c")
		build_valid = true
		build_location = tile_position
	else:
		get_node("UI").update_tower_preview(tile_position,"adff4545")
		print_debug(tile_position)
		build_valid = false
	

func cancel_build_mode():
	pass

func varlify_and_build():
	pass
