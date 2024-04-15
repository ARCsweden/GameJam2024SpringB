extends Window


func split(display_size,world):
	visible = true
	world_2d = world
	const mainWindowId = DisplayServer.MAIN_WINDOW_ID
	
	size = Vector2i(display_size.x / 2,display_size.y)
	position.x = DisplayServer.window_get_position(mainWindowId).x + (display_size.x / 2)
	position.y = DisplayServer.window_get_position(mainWindowId).y
	
	
func fix():
	visible = false
	
