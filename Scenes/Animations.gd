extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func walk():
	play("walkR")
	
func attack():
	play("attack")

func idle():
	play("idle")

func die():
	await play("die")
