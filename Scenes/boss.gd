extends CharacterBody2D

signal delete_me
@export var move_speed := 100

@onready var attack_timer = %AttackTimer
@onready var dialogue = %Dialogue
@onready var split_duration = %SplitDuration

var active_attacks = []

var current_attack : String = ""
var can_attack := true

enum attacks{FPS}
var current_x_direction
var current_y_direction

var attack_functions = [modify_fps]

enum directions{POSITIVE = 1, NEGATIVE = -1, NEUTRAL = 0}
enum axis{x,y}
enum {SPLIT, RESTORE}

var movement = ["up", "down", "left", "right", "up_right", "up_left", "down_right", "down_left"]
var last_attack
# Called when the node enters the scene tree for the first time.
func _ready():
	set_direction(axis.x, directions.POSITIVE)
	set_direction(axis.y, directions.POSITIVE)
	Engine.max_fps = 30
	connect("delete_me",cleanup)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var index = 0
	print(get_child_count())
	for timer in active_attacks:
		if timer.time_left == 0:
			timer.queue_free()
			active_attacks.remove_at(index)
		index += index
func _physics_process(delta):
# Add the gravity.

	velocity.x = move_speed * current_x_direction
	velocity.y = move_speed * current_y_direction
	
	move_and_slide()
	
func special_attack(attribute: int):
	
	var debuff_duration_timer = Timer.new()
	add_child(debuff_duration_timer)
	debuff_duration_timer.wait_time = 5
	debuff_duration_timer.one_shot = true
	
	var current_attack = attack_functions.pick_random()
	
	current_attack.call(SPLIT)
	split_duration.start()
	debuff_duration_timer.connect("timeout", current_attack.bind(RESTORE))
	debuff_duration_timer.start()
	active_attacks.append(debuff_duration_timer)
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
	last_attack.call(RESTORE)
	emit_signal("delete_me")	
	
func modify_attribute(attribute: int, action: int):
	
	match action:
		SPLIT:
			pass
		RESTORE:
			pass

func modify_fps(mode: int):
	
	const normal_fps = 30
	
	match mode:
		SPLIT:
			print("Splitting FPS")
			Engine.max_fps = normal_fps / 2
		RESTORE:
			print("Restoring FPS")
			Engine.max_fps = normal_fps

func _on_attack_timer_timeout():
		special_attack(attacks.FPS)
		
func cleanup(trash : Resource):
	trash.queue_free()
