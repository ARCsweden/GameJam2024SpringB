extends CharacterBody2D

signal delete_me

@export var move_speed := 50


@onready var dialogue = %Dialogue

@export var max_health := 5000
var health

var active_timers = []

var projectile = preload("res://Scenes/projectile.tscn")

var current_x_direction
var current_y_direction

# modify_fps, modify_player_speed, modify_zoom, modify_window_size, modify_player_health, modify_map, 
var attack_functions = [modify_fps, modify_player_speed, modify_zoom, modify_player_health, modify_map]

enum {SPLIT, RESTORE}

enum directions{POSITIVE = 1, NEGATIVE = -1, NEUTRAL = 0}
enum axis{x,y}
var movement = ["up", "down", "left", "right", "up_right", "up_left", "down_right", "down_left"]
var display_size
var target

var id = 0

var state := 0
enum BossStates{idle, melee_attack, special_attack, talking, die}
var is_in_melee_area := false

var turbo = false

var Boss_Bar = GlobalInfo.Boss_Bar



func _ready():
	health = max_health
	GlobalInfo.boss = self
	display_size = DisplayServer.window_get_size()
	target = GlobalInfo.player
	set_direction(axis.x, directions.POSITIVE)
	set_direction(axis.y, directions.POSITIVE)
	Engine.max_fps = 30
	connect("delete_me",cleanup)
	
	GlobalInfo.Boss_Bar.attrib_max = health
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if health < (max_health / 2):
		turbo = true
		
	if turbo:
		$SpecialAttackTimer.wait_time = 5
	if GlobalInfo.player == null:
		queue_free()
	if $MeleeAttackTimer.time_left > 0:
		state = BossStates.melee_attack
	else:
		state = BossStates.idle
		
	match state:
		BossStates.idle:
			$BossSprite.play("idle")
		BossStates.melee_attack:
			$BossSprite.play("melee_attack")
		BossStates.special_attack:
			$BossSprite.play("special_attack")
		BossStates.talking:
			$BossSprite.play("talking")
		BossStates.die:
			$BossSprite.play("die")
			
	
	var index = 0
	for timer in active_timers:
		if timer != null:
			if timer.time_left == 0:
				timer.queue_free()
				active_timers.remove_at(index)
		index += index
func _physics_process(delta):
# Add the gravity.
	if GlobalInfo.player != null:
		velocity = global_position.direction_to(GlobalInfo.player.global_position)
		move_and_collide(velocity * move_speed * delta)
	
	
func special_attack():
	
	var debuff_duration_timer = Timer.new()
	add_child(debuff_duration_timer)

	debuff_duration_timer.wait_time = 15
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
	
func take_damage(damage_taken: int):
	if health - damage_taken <= 0:
		health = 0
		die()
	else:
		health -= damage_taken
		
	GlobalInfo.Boss_Bar.attrib = health
	
func die():
	GlobalInfo.ui.mission_accomplished()
	await get_tree().create_timer(5.0).timeout
	get_tree().reload_current_scene()
	#state = BossStates.die
	#$DieTimer.start()


func ranged_attack():
	var active_projectile = projectile.instantiate()
	GlobalInfo.Boss_Dialog.dialog = "I perform my special move, SPLIT IN TWO!"
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

func melee_attack():
	GlobalInfo.player.take_damage(250)

func _on_melee_area_body_entered(body):
	is_in_melee_area = true
	$MeleeAttackTimer.start()
	
func _on_melee_attack_timer_timeout():
	$MeleeAttackTimer.stop()
	if is_in_melee_area == true:
		$ChillTimer.start()
		melee_attack()

func _on_melee_area_body_exited(body):
	is_in_melee_area = false
	

func _on_chill_timer_timeout():
	$MeleeAttackTimer.start()


func _on_die_timer_timeout():
	queue_free()
