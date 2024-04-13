extends Node2D

var speed:float = 100
var proj_vect : Vector2
var count = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	
	proj_vect = GlobalInfo.player.global_position - GlobalInfo.boss.global_position
	
func _physics_process(delta):
	
	if proj_vect.length() < 70:
		pass
	if count % 100 == 0:
		proj_vect = GlobalInfo.player.global_position - global_position
	global_position += proj_vect.normalized() * speed * delta
	count += count;
func _on_area_2d_body_entered(body):
	GlobalInfo.boss.special_attack()
	queue_free()

