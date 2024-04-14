extends CharacterBody2D

signal hit;

# Health
@export var default_max_health = 1000
var max_health = default_max_health
@export var current_health = default_max_health

#@onready var hp = $"../Bars"/HP
#@onready var energy = $"../Bars"/Energy

@onready var hp = $Bars/HP
@onready var energy = $Bars/Energy

# Movement and Dodge Properties

@export_range(0.0, 1.0) var default_friction = 0.5
@export_range(0.0 , 1.0) var default_acceleration = 0.25
@export var default_speed = 150
@export var default_dodge_speed = 400
@export var default_dodge_duration = 0.2
@export var default_dodge_cooldown = 1


var default_zoom := 4

@export var friction = default_friction
@export var acceleration = default_acceleration
@export var speed = default_speed

var dodge_speed = default_dodge_speed

var dodging = false
var dodge_duration = default_dodge_duration
var dodge_cooldown = default_dodge_cooldown  # Cooldown duration in seconds
var can_dodge = true      # Flag to check if dodge can be triggered
var axis = Vector2.ZERO

var game_is_over = false

var cooldown_timer

enum PlayerState{idle,walkingL,walkingR,attacking}
var currentState = PlayerState.idle

var can_attack = true
@export var attack_dmg = 100

func _ready():
	
	# Initialize Timer for attack state duration
	GlobalInfo.player = self
	var attack_timer = Timer.new()
	attack_timer.name = "AttackTimer"
	attack_timer.wait_time = 0.3
	attack_timer.one_shot = true
	add_child(attack_timer)
	attack_timer.timeout.connect(_end_attack)
	
		
	# Initialize Timer for dodge duration
	GlobalInfo.player = self
	var dodge_timer = Timer.new()
	dodge_timer.name = "DodgeTimer"
	dodge_timer.wait_time = dodge_duration
	dodge_timer.one_shot = true
	add_child(dodge_timer)
	dodge_timer.timeout.connect(_end_dodge)

	# Initialize Timer for dodge cooldown
	cooldown_timer = Timer.new()
	cooldown_timer.name = "CooldownTimer"
	cooldown_timer.wait_time = dodge_cooldown
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)
	cooldown_timer.timeout.connect(_reset_dodge)
	
	# Initilize stuff for bar UI
	hp.attrib_max = default_max_health
	energy.attrib_max = dodge_cooldown
	


func _process(_delta):
	var local_velocity = Vector2.ZERO
	
	energy.attrib = dodge_cooldown - cooldown_timer.get_time_left()


func _physics_process(delta):
	
	
	
	if Input.is_action_just_pressed("attack") and can_attack:
		start_attack()
		

	if Input.is_action_just_pressed("dodge") and can_dodge:
		start_dodge()
	
	axis.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	axis.y = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")

	axis = axis.normalized() * (dodge_speed if dodging else speed)

	if axis == Vector2.ZERO:
		if (currentState!=PlayerState.attacking):
			currentState=PlayerState.idle
			$Animations.idle()
		velocity = velocity.lerp(axis, friction)
	else:
		if (currentState!=PlayerState.attacking):
			if axis.x >= 0:
				currentState=PlayerState.walkingR
				$Animations.flip_h = false
				$Bars.position.x = -40
			elif axis.x < 0:
				currentState=PlayerState.walkingL
				$Animations.flip_h = true
				$Bars.position.x = -15
			$Animations.walk()
		velocity = velocity.lerp(axis, acceleration)
	
	move_and_slide()

# Function to start dodging
func start_dodge():
	modulate="ffffff50"
	$DodgeSound.play()
	set_collision_layer_value(2,false)
	set_collision_mask_value(3,false)
	set_collision_mask_value(10,false)
	dodging = true
	can_dodge = false
	get_node("DodgeTimer").start()  # Start the dodge duration timer
	get_node("CooldownTimer").start()  # Start the cooldown timer
	
	energy.attrib = 0

# Function to end dodging
func _end_dodge():
	modulate="ffffff"
	set_collision_layer_value(2,true)
	set_collision_mask_value(3,true)
	set_collision_mask_value(10,true)
	dodging = false

# Function to reset dodge availability
func _reset_dodge():
	can_dodge = true
	
	energy.attrib = dodge_cooldown
	
func set_speed(new_speed: int):
	speed = new_speed
	
func set_zoom(new_zoom : Vector2):
	$Camera2D.zoom = new_zoom
	
func set_health(new_health: int):
	current_health = new_health
		
		
func game_over():
	if !game_is_over:
		game_is_over = true
		GlobalInfo.ui.game_over()
		await get_tree().create_timer(5.0).timeout
		get_tree().reload_current_scene()
	
func start_attack():
	currentState=PlayerState.attacking
	can_attack=false
	get_node("AttackTimer").start()
	$AttackSound.play()
	$Animations.attack()
	$AttackHitReg/AttackHitBox.set_disabled(false)

func _end_attack():
	$AttackHitReg/AttackHitBox.set_disabled(true)
	can_attack=true
	currentState=PlayerState.idle

	hp.value = current_health
	
func take_damage(damage_taken: int):
	if current_health - damage_taken <= 0:
		current_health = 0
		game_over()
	else:
		current_health -= damage_taken
	hp.value = current_health
	
func die():
	queue_free()

func _on_attack_hit_reg_body_entered(body):
	$AttackHitSound.play()
	GlobalInfo.boss.take_damage(attack_dmg)
