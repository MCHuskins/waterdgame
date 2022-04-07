extends Node2D

var map_node
var mstr
var pv

var build_mode = false
var build_valid = false
var build_location
var build_type
var build_tile
var current_wave = 0
var enemies_in_wave
var can_stat = true
var townshow = false

func _ready():
	map_node = get_node("Map 1")
	mstr = get_node("UI/HUD/Infobar/money")
	for i in get_tree().get_nodes_in_group('bb'):
		i.connect("pressed",self,"initiate_build_mode",[i.get_name()])


func _physics_process(delta):
	mstr.text =str(Playerstats.money)
	if Playerstats.enimes <= 0 and can_stat == true:
		can_stat = false
		start_next_wave()
	if not townshow and Playerstats.money >= 20:
		townshow = true
		buytowerhelp()

func _process(delta):
	if build_mode:
		update_tower_preview()

func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
		Playerstats.money += 20
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()


func buytowerhelp():
	$UI/buyatower.show()
	yield(get_tree().create_timer(5.0),"timeout")
	$UI/buyatower.hide()

##
##wave thigns
##

var waves = [
	[["mud", 1], ["buletank",1.1], ["mud", 1], ["buletank", 1.7], ["mud", 1], ["buletank", 1], ["mud", 1], ["buletank", 2.7], ["buletank", 1],["mud", 1], ["buletank",1.1], ["buletank", 1.7], ["mud", 1], ["buletank", 1], ["buletank", 1.7],["buletank",1.1],["boss",1.1]],
[["wait", 3], ["buletank", 2.7], ["mud", 1],["buletank", 1], ["mud", 1],["buletank",1.1], ["buletank", 1.7],["mud", 1],["buletank", 2.7], ["buletank", 1], ["mud", 1], ["buletank",1.1], ["buletank", 1.7], ["buletank", 1], ["buletank", 1],["mud", 1], ["boss", 1.7],["boss",1.1]],
[["wait", 3],["buletank", 1], ["mud", 1], ["buletank",1.1], ["mud", 1], ["buletank", 1.7], ["buletank", 1], ["buletank", 2.7], ["buletank", 1],["mud", 1], ["buletank",1.1], ["mud", 1], ["buletank", 1.7], ["buletank", 1], ["boss", 1.7],["boss",1.1],["boss",1.1]],
[["wait", 3],["buletank", 1], ["mud", 1], ["buletank",1.1], ["buletank", 1.7], ["boss", 1], ["boss", 1], ["boss", 1.7],["boss",1.1], ["boss", 1], ["boss",1.1]],
]


func start_next_wave():
	var wave_deta = retrieve_wave_deta()
	yield(get_tree().create_timer(0.0),"timeout")
	spawn_enemies(wave_deta)
	howtoplay()
	
func retrieve_wave_deta():
	var wave_delta = []
	if current_wave <= waves.size()-1:
		wave_delta = waves[current_wave]
	else:
		$UI/youwin.show()
		$UI/restart.show()
	current_wave += 1
	Playerstats.enimes = wave_delta.size()
	can_stat = true
	return wave_delta
	
func spawn_enemies(wave_delta):
	for i in wave_delta:
		if i[0] == "wait":
			tellaboutnext()
			yield(get_tree().create_timer(i[1]),"timeout")
			Playerstats.enimes -= 1
		elif rand_range(0,4) > 2:
			var new_enemy = load("res://Rescources/enemies/" + i[0] + ".tscn").instance()
			map_node.get_node("Path2D").add_child(new_enemy, true)
			yield(get_tree().create_timer(i[1]),"timeout")
		else:
			var new_enemy = load("res://Rescources/enemies/" + i[0] + ".tscn").instance()
			map_node.get_node("Path").add_child(new_enemy, true)
			yield(get_tree().create_timer(i[1]),"timeout")

func howtoplay():
	yield(get_tree().create_timer(9.0),"timeout")
	$UI/clickwave.hide()
func tellaboutnext():
	$UI/nextwave.show()
	yield(get_tree().create_timer(2.0),"timeout")
	$UI/nextwave.hide()
##
## build thigns
##
func initiate_build_mode(tower_type):
	if build_mode:
		cancel_build_mode()
	if Playerstats.money >= Gamedata.tower_data[tower_type]["cost"]:
		Playerstats.money -= Gamedata.tower_data[tower_type]["cost"]
		build_type = tower_type
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
	else:
		Playerstats.money += 20
		


func _on_restart_button_down():
	Playerstats.restart = true
	current_wave = 0
	get_tree().paused = false

