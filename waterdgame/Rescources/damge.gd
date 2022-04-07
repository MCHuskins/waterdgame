extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print("yah")
	go()
func go():
	yield(get_tree().create_timer(2),"timeout")
	print("dei")
	self.queue_free()
