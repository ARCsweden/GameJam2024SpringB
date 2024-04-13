extends CharacterBody2D

@export var move_speed := 100

@onready var attack_timer = %AttackTimer
@onready var dialogue = %Dialogue

var current_attack : String = ""
var can_attack := true

enum attack_attributes{FPS, }
var current_x_direction
var current_y_direction

enum directions{POSITIVE_Y = 1, NEGATIVE_Y = -1, NEGATIVE_X = -1, POSITIVE_X = 1}

var movement = ["up", "down", "left", "right", "up_right", "up_left", "down_right", "down_left"]

enum {UP, DOWN, LEFT, RIGHT, UP_RIGHT, UP_LEFT, DOWN_RIGHT, DOWN_LEFT}

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready():
	print(movement.pick_random())
	current_x_direction = directions.POSITIVE_X
	current_y_direction = directions.POSITIVE_Y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_direction(direction: int):
	
	if direction == directions.POSITIVE_Y:
		current_y_direction = directions.POSITIVE_Y
	elif direction == directions.NEGATIVE_Y:
		current_y_direction = directions.NEGATIVE_Y
	elif direction == directions.NEGATIVE_X:
		current_x_direction = directions.NEGATIVE_X
	elif direction == directions.POSITIVE_X:
		current_x_direction = directions.POSITIVE_X
	
func _physics_process(delta):
# Add the gravity.

	velocity.x = move_speed * current_x_direction
	velocity.y = move_speed * current_y_direction
	
	move_and_slide()


func special_attack(attribute: int):
	can_attack = false
	attack_timer.start()
	


func _on_special_attack_timer_timeout():
	can_attack = true

func choose_movement_action(action : String):

	match action:
		"up": #Up
			set_direction(directions.POSITIVE_Y)
		"down": #Down
			set_direction(directions.NEGATIVE_Y)
		"left": #Left
			set_direction(directions.NEGATIVE_X)
		"right": #Right
			set_direction(directions.POSITIVE_X)
		"up_right": #Up-Right
			set_direction(directions.POSITIVE_Y)
			set_direction(directions.POSITIVE_X)
		"up_left": #Up-Left
			set_direction(directions.POSITIVE_Y)
			set_direction(directions.NEGATIVE_X)
		"down_right": #Down-Right
			set_direction(directions.NEGATIVE_Y)
			set_direction(directions.POSITIVE_X)
		"down_left": #Down - Left
			set_direction(directions.NEGATIVE_Y)
			set_direction(directions.NEGATIVE_X)
			
	print("Action chosen: " + action)
func _on_action_timer_timeout():
	
	choose_movement_action(movement.pick_random())
	
