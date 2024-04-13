extends Node2D

var tile_scene = preload("res://path/to/GroundTile.tscn")
var tile_width = 64  # Width of the tile, adjust according to your tile's width
var tile_height = 64  # Height of the tile, adjust according to your tile's height

func _ready():
	var viewport_size = get_viewport_rect().size
	var num_tiles_x = int(viewport_size.x / tile_width) + 2  # +2 for extra coverage
	var num_tiles_y = int(viewport_size.y / tile_height) + 2  # +2 for extra coverage
	
	for x in range(num_tiles_x):
		for y in range(num_tiles_y):
			var tile = tile_scene.instance()
			tile.position = Vector2(x * tile_width, y * tile_height)
			add_child(tile)

	# Optionally add a script to each tile to handle repositioning if they go offscreen
	_setup_tile_movement()

func _setup_tile_movement():
	for tile in get_children():
		tile.connect("screen_exited", self, "_on_tile_screen_exited", [tile])

func _on_tile_screen_exited(tile):
	var new_x = tile.position.x
	var new_y = tile.position.y - tile_height * get_child_count()  # Move it back to the start
	tile.position = Vector2(new_x, new_y)
