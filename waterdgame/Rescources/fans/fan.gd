extends Node2D

var enemy_array = []
var built = false

func _ready():
	if built:
		self.get_node("Range/CollisionsShape2D").get_shape().radius = 0.5 * Gamedata.tower_data[self.get.name()]["range"]

func _physics_process(delta):
	turn()
	
func turn():
	var enemy_position = get_global_mouse_position()
	get_node("top").look_at(enemy_position)

func _on_range_body_entered(body):
	enemy_array.append(body.get_parent())


func _on_range_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	enemy_array.erase(body.get_parent())
