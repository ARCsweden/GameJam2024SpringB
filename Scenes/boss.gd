extends CharacterBody2D

signal delete_me
@export var move_speed := 100

class attack:
	var attack_func_ref
	var type = ""

@onready var attack_timer = %AttackTimer
@onready var dialogue = %Dialogue
@onready var split_duration = %SplitDuration

var active_timers = []
var active_attacks = []
var can_attack := true

enum attacks{FPS}
var current_x_direction
var current_y_direction

var attack_functions = [modify_fps, modify_player_speed]

enum directions{POSITIVE = 1, NEGATIVE = -1, NEUTRAL = 0}
enum axis{x,y}
enum {SPLIT, RESTORE}

var movement = ["up", "down", "left", "right", "up_right", "up_left", "down_right", "down_left"]
var last_attack
# Called when the node enters the scene tree for the first time.
var target

func _ready():
	target = GlobalInfo.player
	set_direction(axis.x, directions.POSITIVE)
	set_direction(axis.y, directions.POSITIVE)
	Engine.max_fps = 30
	connect("delete_me",cleanup)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var index = 0
	for timer in active_timers:
		if timer.time_left == 0:
			timer.queue_free()
			active_timers.remove_at(index)
		index += index
func _physics_process(_delta):
# Add the gravity.

	velocity.x = move_speed * current_x_direction
	velocity.y = move_speed * current_y_direction
	
	move_and_slide()
	
func special_attack():
	
	var debuff_duration_timer = Timer.new()
	add_child(debuff_duration_timer)
	debuff_duration_timer.wait_time = 5
	debuff_duration_timer.one_shot = true
	
	
	var current_attack

	while true:
		current_attack = attack_functions.pick_random()
		var count = 0
		for attack in active_attacks:
			if current_attack == attack:
				count += 1
		if count == 0:
			break
	current_attack.call(SPLIT)
	split_duration.start()
	debuff_duration_timer.connect("timeout", current_attack.bind(RESTORE))
	debuff_duration_timer.start()
	active_timers.append(debuff_duration_timer)
	
	active_attacks.append(active_attacks)
	
	last_attack = current_attack

func set_direction(temp :int, direction: int):
	
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


func _on_split_duration_timeout():
	emit_signal("delete_me")	
	
func modify_fps(mode: int):
	
	const normal_fps = 30
	
	match mode:
		SPLIT:
			Engine.max_fps = normal_fps / 2
			print("Splitting FPS")
		RESTORE:
			Engine.max_fps = normal_fps
			print("Restoring FPS")

func modify_player_speed(mode: int):
	
	match mode:
		SPLIT:
			target.set_speed(target.speed / 2)
			print("Splitting Speed")
		RESTORE:
			GlobalInfo.player.set_speed(target.original_speed)
			print("Restoring Speed")
	
func _on_attack_timer_timeout():
		special_attack()
		
func cleanup(trash : Resource):
	trash.queue_free()

