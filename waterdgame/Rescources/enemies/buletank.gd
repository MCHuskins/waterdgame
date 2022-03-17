extends PathFollow2D


var speed = 140
var hp = 50
var base_damage = 21

onready var healthbar = get_node("helth")


func _ready():
	healthbar.max_value = hp*2
	healthbar.value = hp*2
	healthbar.set_as_toplevel(true)

func _physics_process(delta):
	move(delta)
	
func move(delta):
	set_offset(get_offset()+speed*delta)
	healthbar.set_position(position - Vector2(30,30))

func on_hit(damage):
	hp -= damage
	healthbar.value = hp *2
	if hp <= 0:
		Playerstats.money += 5
		on_destroy()

func on_destroy():
	self.queue_free()
