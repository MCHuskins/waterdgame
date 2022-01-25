extends Node

func _ready():
	get_node("MainMenu/m/vb/Newgame").connect("pressed",self,"on_new_game_pressed")
	get_node("MainMenu/m/vb/quit").connect("pressed",self,"on_quit_pressed")
	
func on_quit_pressed():
	get_tree().quit()
	
func on_new_game_pressed():
	get_node("MainMenu").queue_free()
	var game_scence = load("res://Scenes/GameScene.tscn").instance()
	add_child(game_scence)
