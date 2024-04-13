extends CharacterBody2D

signal hit;


# Health
@export var default_max_health = 1000
var max_health = default_max_health
@export var current_health = default_max_health

# Movement and Dodge Properties
@export_range(0.0, 1.0) var default_friction = 0.1
@export_range(0.0 , 1.0) var default_acceleration = 0.1
@export var default_speed = 150
@export var default_dodge_speed = 900
@export var default_dodge_duration = 0.05
@export var default_dodge_cooldown = 1

@export var friction = default_friction
@export var acceleration = default_acceleration
@export var speed = default_speed
var dodge_speed = default_dodge_speed

@export var dodging = false
var dodge_duration = default_dodge_duration
var dodge_cooldown = default_dodge_cooldown  # Cooldown duration in seconds
@export var can_dodge = true      # Flag to check if dodge can be triggered
var axis = Vector2.ZERO

func _ready():
	# Initialize Timer for dodge duration
	var dodge_timer = Timer.new()
	dodge_timer.name = "DodgeTimer"
	dodge_timer.wait_time = dodge_duration
	dodge_timer.one_shot = true
	add_child(dodge_timer)
	dodge_timer.timeout.connect(_end_dodge)

	# Initialize Timer for dodge cooldown
	var cooldown_timer = Timer.new()
	cooldown_timer.name = "CooldownTimer"
	cooldown_timer.wait_time = dodge_cooldown
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)
	cooldown_timer.timeout.connect(_reset_dodge)
	
	# Save screen size for bounds detection

	
func _process(delta):
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("attack"):
		$Sword.swing()

	if Input.is_action_just_pressed("dodge") and can_dodge:
		start_dodge()
	
	axis.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	axis.y = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")

	axis = axis.normalized() * (dodge_speed if dodging else speed)

	if axis == Vector2.ZERO:
		velocity = velocity.lerp(axis, friction)
	else:
		velocity = velocity.lerp(axis, acceleration)

	move_and_slide()

# Function to start dodging
func start_dodge():
	dodging = true
	can_dodge = false
	get_node("DodgeTimer").start()  # Start the dodge duration timer
	get_node("CooldownTimer").start()  # Start the cooldown timer

# Function to end dodging
func _end_dodge():
	dodging = false

# Function to reset dodge availability
func _reset_dodge():
	can_dodge = true
