extends Sprite2D

func swing():
	if flip_v == true:
		flip_v = false
	else:
		flip_v = true
	
	#$AnimationPlayer.play("swing")
