extends CharacterBody2D

# Movement and Dodge Properties
var speed = 300
var dodge_speed = 2000
var dodging = false
var dodge_duration = 0.05
var dodge_cooldown = 1  # Cooldown duration in seconds
var can_dodge = true      # Flag to check if dodge can be triggered

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

func _process(delta):
	var local_velocity = Vector2.ZERO

	if Input.is_action_just_pressed("attack"):
		$Sword.swing()

	# Handle normal movement
	if Input.is_action_pressed("ui_right"):
		local_velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		local_velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		local_velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		local_velocity.y -= 1

	if local_velocity.length() > 0:
		local_velocity = local_velocity.normalized() * (dodge_speed if dodging else speed)

	# Check for dodge input
	if Input.is_action_just_pressed("dodge") and can_dodge:
		start_dodge(local_velocity.normalized() * dodge_speed if local_velocity.length() > 0 else Vector2(speed, 0))

	# Apply the calculated velocity
	self.velocity = local_velocity
	move_and_slide()

# Function to start dodging
func start_dodge(dodge_dir):
	dodging = true
	can_dodge = false
	self.velocity = dodge_dir
	get_node("DodgeTimer").start()  # Start the dodge duration timer
	get_node("CooldownTimer").start()  # Start the cooldown timer

# Function to end dodging
func _end_dodge():
	dodging = false
	self.velocity = Vector2.ZERO  # Reset velocity

# Function to reset dodge availability
func _reset_dodge():
	can_dodge = true
