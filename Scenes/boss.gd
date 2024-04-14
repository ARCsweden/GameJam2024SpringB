extends CharacterBody2D

signal delete_me

@export var move_speed := 100

@onready var attack_timer = %AttackTimer
@onready var dialogue = %Dialogue

var active_timers = []

var projectile = preload("res://Scenes/projectile.tscn")

var current_x_direction
var current_y_direction
# modify_fps, modify_player_speed, modify_zoom, modify_resolution, 
var attack_functions = [modify_player_health]#[modify_fps, modify_player_speed, modify_zoom, modify_resolution, modify_player_health, modify_map]
enum {SPLIT, RESTORE}

enum directions{POSITIVE = 1, NEGATIVE = -1, NEUTRAL = 0}
enum axis{x,y}
var movement = ["up", "down", "left", "right", "up_right", "up_left", "down_right", "down_left"]
var display_size
var target
var id = 0

func _ready():
	GlobalInfo.boss = self
	display_size = DisplayServer.window_get_size()
	target = GlobalInfo.player
	set_direction(axis.x, directions.POSITIVE)
	set_direction(axis.y, directions.POSITIVE)
	Engine.max_fps = 30
	connect("delete_me",cleanup)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var index = 0
	for timer in active_timers:
		if timer != null:
			if timer.time_left == 0:
				timer.queue_free()
				active_timers.remove_at(index)
		index += index
func _physics_process(_delta):
# Add the gravity.

	#velocity.x = move_speed * current_x_direction
	#velocity.y = move_speed * current_y_direction
	
	move_and_slide()
	
func special_attack():
	
	var debuff_duration_timer = Timer.new()
	add_child(debuff_duration_timer)
	debuff_duration_timer.wait_time = 5
	debuff_duration_timer.one_shot = true
	
	var	current_attack = attack_functions.pick_random()
	id += 1
	current_attack.call(id, SPLIT)
	debuff_duration_timer.connect("timeout", current_attack.bind(id, RESTORE))
	debuff_duration_timer.start()
	active_timers.append(debuff_duration_timer)
	
func set_direction(temp: int, direction: int):
	
	match temp:
		axis.x:
			current_x_direction = direction
		axis.y:
			current_y_direction = direction

func choose_movement_action(action : String):

	match action:
		"up": #Up
			set_direction(axis.y, directions.POSITIVE)
			set_direction(axis.x, directions.NEUTRAL)
		"down": #Down
			set_direction(axis.y, directions.NEGATIVE)
			set_direction(axis.x, directions.NEUTRAL)
		"left": #Left
			set_direction(axis.x, directions.NEGATIVE)
			set_direction(axis.y, directions.NEUTRAL)
		"right": #Right
			set_direction(axis.x, directions.POSITIVE)
			set_direction(axis.y, directions.NEUTRAL)
		"up_right": #Up-Right
			set_direction(axis.y, directions.POSITIVE)
			set_direction(axis.x, directions.POSITIVE)
		"up_left": #Up-Left
			set_direction(axis.y, directions.POSITIVE)
			set_direction(axis.x, directions.NEGATIVE)
		"down_right": #Down-Right
			set_direction(axis.y, directions.NEGATIVE)
			set_direction(axis.x, directions.POSITIVE)
		"down_left": #Down - Left
			set_direction(axis.y, directions.NEGATIVE)
			set_direction(axis.x, directions.NEGATIVE)
	
func _on_action_timer_timeout():
	choose_movement_action(movement.pick_random())

func ranged_attack():
	var active_projectile = projectile.instantiate()
	add_child(active_projectile)
	
func _on_attack_timer_timeout():
		ranged_attack()
	
func modify_fps(id: int, mode: int):
	
	const normal_fps = 30
	const name = "FPS SPLIT"
	
	match mode:
		SPLIT:
			Engine.max_fps = normal_fps / 2
			print("Splitting FPS")
			GlobalInfo.ui.add_debuff(id, name)
		RESTORE:
			Engine.max_fps = normal_fps
			print("Restoring FPS")
			GlobalInfo.ui.remove_debuff(id)

func modify_player_speed(id: int, mode: int):
	const name = "SPEED SPLIT"
	match mode:
		SPLIT:
			target.set_speed(target.speed / 2)
			print("Splitting Speed")
			GlobalInfo.ui.add_debuff(id, name)
		RESTORE:
			GlobalInfo.player.set_speed(target.default_speed)
			print("Restoring Speed")
			GlobalInfo.ui.remove_debuff(id)
	
func modify_zoom(id: int, mode: int):
	const name = "ZOOM SPLIT"
	match mode:
		SPLIT:
			target.set_zoom(Vector2(target.default_zoom / 2, target.default_zoom / 2))
			print("Splitting Zoom")
			GlobalInfo.ui.add_debuff(id, name)
		RESTORE:
			target.set_zoom(Vector2(target.default_zoom, target.default_zoom))
			print("Restoring Zoom")
			GlobalInfo.ui.remove_debuff(id)
			
func modify_resolution(id: int, mode: int):
	const name = "WINDOW SPLIT"
	var curr_size = DisplayServer.window_get_size()
	match mode:
		SPLIT:
			DisplayServer.window_set_size(curr_size / 2)
			print("Splitting Resolution")
			GlobalInfo.ui.add_debuff(id, name)
		RESTORE:			
			DisplayServer.window_set_size(display_size)			
			print("Splitting Resolution")
			GlobalInfo.ui.remove_debuff(id)
		

func modify_map(id: int, mode: int):
	const name = "WORLD SPLIT"
	match mode:
		SPLIT:
			GlobalInfo.arena.splitTheWorld()
			GlobalInfo.ui.add_debuff(id, name)
		RESTORE:
			GlobalInfo.arena.fixTheWorld()
			GlobalInfo.ui.remove_debuff(id)
			
func modify_player_health(id: int, mode: int):
	const name = "HEALTH SPLIT"
	match mode:
		SPLIT:
			GlobalInfo.player.set_health(GlobalInfo.player.current_health / 2)
			GlobalInfo.ui.add_debuff(id, name)
		RESTORE:
			GlobalInfo.player.set_health(GlobalInfo.player.current_health * 2)
			GlobalInfo.ui.remove_debuff(id)



func cleanup(trash : Resource):
	trash.queue_free()

