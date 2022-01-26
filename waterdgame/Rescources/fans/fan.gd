extends Node2D

var type
var enemy_array = []
var built = false
var enemy
var ready = true

func _ready():
	if built:
		self.get_node("range/CollisionShape2D").get_shape().radius = 0.5 * Gamedata.tower_data[type]["range"]

func _physics_process(delta):
	if enemy_array.size() != 0 and built:
		select_enemy()
		turn()
		if ready:
			fire()
	else:
		enemy = null

	
func turn():
	get_node("top").look_at(enemy.position)

func fire():
	ready = false
	enemy.on_hit(Gamedata.tower_data[type]["damage"])
	yield(get_tree().create_timer(Gamedata.tower_data[type]["ref"]), "timeout")
	ready = true

func select_enemy():
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.offset)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]	



func _on_range_body_entered(body):
	enemy_array.append(body.get_parent())


func _on_range_body_exited(body):
	enemy_array.erase(body.get_parent())
