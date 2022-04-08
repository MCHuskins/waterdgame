extends CanvasLayer
var tower_range = 350
var heath
func _ready():
	heath = Playerstats.health
	$HUD/Infobar/h/helth.max_value =  Playerstats.health


func set_tower_preview(tower_type,mouse_position):
	var drag_tower = load("res://Rescources/fans/" + tower_type + ".tscn").instance()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("ad54ff3c")
	var range_texture = Sprite.new()
	range_texture.position = Vector2(32,32)
	var scaling = Gamedata.tower_data[tower_type]["range"] / 600.0
	range_texture.scale = Vector2(scaling,scaling)
	var texture = load("res://Assets/junk/range_overlay.png")
	range_texture.texture = texture
	range_texture.set_name("rangee")

	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.add_child(range_texture, true)
	control.rect_position = mouse_position 
	control.set_name("TowerPreview")
	add_child(control,true)
	move_child(get_node("TowerPreview"),0)
	
func update_tower_preview(new_position, color):
	get_node("TowerPreview").rect_position = new_position
	if get_node("TowerPreview/DragTower").modulate != Color(color):
		get_node("TowerPreview/DragTower").modulate = Color(color)
		get_node("TowerPreview/rangee").modulate = Color(color)


func _on_playpause_pressed():
	if get_parent().build_mode:
		get_parent().cancel_build_mode()
	if get_tree().is_paused():
		get_tree().paused = false
	else:
		get_tree().paused = true


func _on_speedup_pressed():
	if get_parent().build_mode:
		get_parent().cancel_build_mode()
	if Engine.get_time_scale()== 5:
#		$UI/HUD/GameControls/speedup2.
		Engine.set_time_scale(1.0)
	elif Engine.get_time_scale()== 3:
		Engine.set_time_scale(5)
	else:
		Engine.set_time_scale(3)
		

func _physics_process(delta):
	$HUD/Infobar/h/helth.value =  abs(heath -Playerstats.health)
	if Playerstats.health <= 0:
		get_tree().paused = true
		$youlose.show()
		$restart.show()
