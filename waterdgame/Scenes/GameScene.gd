extends Node2D

var map_node

var build_mode = false
var build_valid = false
var build_location
var build_type
var build_tile
var current_wave = 0
var enemies_in_wave

func _ready():
	map_node = get_node("Map 1")
	for i in get_tree().get_nodes_in_group('bb'):
		i.connect("pressed",self,"initiate_build_mode",[i.get_name()])


func _process(delta):
	if build_mode:
		update_tower_preview()

func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()


##
##wave thigns
##

func start_next_wave():
	var wave_deta = retrieve_wave_deta()
	yield(get_tree().create_timer(0.0),"timeout")
	spawn_enemies(wave_deta)
	
func retrieve_wave_deta():
	var wave_delta = [["buletank", 1.7], ["buletank",0.1], ["buletank", 2.7], ["buletank",0.1]]
	for i in range(current_wave):
		wave_delta.append(["buletank", 1.7])
		wave_delta.append(["buletank",0.1])
	current_wave += 1
	enemies_in_wave = wave_delta.size()
	return wave_delta
	
func spawn_enemies(wave_delta):
	for i in wave_delta:
		var new_enemy = load("res://Rescources/enemies/" + i[0] + ".tscn").instance()
		map_node.get_node("Path").add_child(new_enemy, true)
		yield(get_tree().create_timer(i[1]),"timeout")
	yield(get_tree().create_timer(1.0),"timeout")
	start_next_wave()


##
## build thigns
##
func initiate_build_mode(tower_type):
	if build_mode:
		cancel_build_mode()
	build_type = tower_type + "t1"
	build_mode = true
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position())
	
func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var current_tile = map_node.get_node("notower").world_to_map(mouse_position)
	var tile_position = map_node.get_node("notower").map_to_world(current_tile)
	
	if map_node.get_node("notower").get_cellv(current_tile)==-1:
		get_node("UI").update_tower_preview(tile_position,"ad54ff3c")
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
	else:
		get_node("UI").update_tower_preview(tile_position,"adff4545")
		build_valid = false
	
func cancel_build_mode():
	build_mode = false
	build_valid = false
	get_node("UI/TowerPreview").free()

func verify_and_build():
	if build_valid:
		var new_tower = load("res://Rescources/fans/" + build_type + ".tscn").instance()
		new_tower.position = build_location
		new_tower.built = true
		new_tower.type = build_type
		map_node.get_node("Towers").add_child(new_tower,true)
		map_node.get_node("notower").set_cellv(build_tile,5)
		
