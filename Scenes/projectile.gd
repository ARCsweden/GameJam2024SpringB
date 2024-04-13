extends Node2D

var speed:float = 200
var proj_vect
# Called when the node enters the scene tree for the first time.
func _ready():
	
	proj_vect = GlobalInfo.player.global_position - GlobalInfo.boss.global_position

func _physics_process(delta):
	
	global_position += proj_vect * delta


func _on_area_2d_body_entered(body):
	print("Launching attack")
	GlobalInfo.boss.special_attack()
	queue_free()

