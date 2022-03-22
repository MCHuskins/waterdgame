extends PathFollow2D


var speed = 70
var hp = 50
var end = 0
var reward = 3

onready var healthbar = get_node("helth")


func _ready():
	healthbar.max_value = hp*2
	healthbar.value = hp*2
	healthbar.set_as_toplevel(true)

func _physics_process(delta):
	on_hit(get_node("KinematicBody2D/Sprite").dtt)
	get_node("KinematicBody2D/Sprite").dtt = 0
	move(delta)
	if end == get_offset():
		Playerstats.health -= int(hp/5)
		on_destroy()
	else:
		end = get_offset()
	
func move(delta):
	set_offset(get_offset()+speed*delta)
	healthbar.set_position(position - Vector2(30,30))

func on_hit(damage):
	hp -= damage
	healthbar.value = hp *2
	if hp <= 0:
		Playerstats.money += reward
		on_destroy()


func on_destroy():
	Playerstats.enimes -= 1
	print(Playerstats.enimes)
	self.queue_free()
