extends Node
var count = 0

func _ready():
	get_node("MainMenu/m/vb/Newgame").connect("pressed",self,"on_new_game_pressed")
	get_node("MainMenu/m/vb/quit").connect("pressed",self,"on_quit_pressed")
	
func on_quit_pressed():
	get_tree().quit()
	
func on_new_game_pressed():
	if count == 10:
		Playerstats.money = 69420
	get_node("MainMenu").queue_free()
	var game_scence = load("res://Scenes/GameScene.tscn").instance()
	add_child(game_scence)

#Konami Code
func _input(ev):
	if ev is InputEventKey and ev.pressed:
		if Input.is_key_pressed(KEY_UP) and count == 0:
			count += 1
		elif Input.is_key_pressed(KEY_UP) and count == 1:
			count += 1
		elif Input.is_key_pressed(KEY_DOWN) and count == 2:
			count += 1
		elif Input.is_key_pressed(KEY_DOWN) and count == 3:
			count += 1
		elif Input.is_key_pressed(KEY_LEFT) and count == 4:
			count += 1
		elif Input.is_key_pressed(KEY_RIGHT) and count == 5:
			count += 1
		elif Input.is_key_pressed(KEY_LEFT) and count == 6:
			count += 1
		elif Input.is_key_pressed(KEY_RIGHT) and count == 7:
			count += 1
		elif Input.is_key_pressed(KEY_A) and count == 8:
			count +=1
		elif Input.is_key_pressed(KEY_B) and count == 9:
			count +=1
		elif count >= 1:
			count = 0

func _physics_process(delta):
	if Playerstats.restart:
		Playerstats.money =0
		Playerstats.clickdam = 20
		Playerstats.health = 7
		Playerstats.enimes = 0
		Playerstats.restart = false
		Playerstats.score = 0
		get_node("GameScene").free()
		var game_scence = load("res://Scenes/GameScene.tscn").instance()
		add_child(game_scence)
