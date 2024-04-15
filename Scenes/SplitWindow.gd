extends Window
	
func split(display_size,world):
	visible = true
	world_2d = world
	const mainWindowId = DisplayServer.MAIN_WINDOW_ID
	
	size = Vector2i(display_size.x / 2,display_size.y)
	position.x = DisplayServer.window_get_position(mainWindowId).x + (display_size.x / 2) + 10
	position.y = DisplayServer.window_get_position(mainWindowId).y
	
	
	
func _process(delta):
	#position = get_node("..").position           BIG NONO, BUT FUNNY
	$Win2Cam.position = get_node("..").position
	pass
	
func fix():
	visible = false
	
