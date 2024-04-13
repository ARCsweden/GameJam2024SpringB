extends Node2D

func _ready():
	fixTheWorld()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func splitTheWorld():
	$ArenaL.position.x = -16
	$ArenaR.position.x = 16+544
	$Void.visible = true
	$Void/Area2D/CollisionShape2D.disabled = false
	
	
func fixTheWorld():
	$ArenaL.position.x = 0
	$ArenaR.position.x = 544
	$Void.visible = false
	$Void/Area2D/CollisionShape2D.disabled = true
