extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func walk():
	play("walk")
	
func attack():
	play("attack")

func idle():
	play("idle")
