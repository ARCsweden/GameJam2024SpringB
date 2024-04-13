extends Node2D

func _ready():
	GlobalInfo.arena = self
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func splitTheWorld():
	$ArenaL.position.x = -16
	$ArenaR.position.x = 16+544
	$Void.visible = true
	$Void/Area2D.set_collision_layer_value(10,true)
	
	
func fixTheWorld():
	$ArenaL.position.x = 0
	$ArenaR.position.x = 544
	$Void.visible = false
	$Void/Area2D.set_collision_layer_value(10,false)
	
	
