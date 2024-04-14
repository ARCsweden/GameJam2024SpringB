extends Control

@export var debuffDict = {}
@onready var DebuffList = $DebuffList
@onready var GameOverRect = $GameOver/GameOverRect
@onready var GameOverAnim = $GameOver/GameOverAnimation
@onready var GameOverText = $GameOver/GameOverText
@onready var MissionAccomplishedRect = $MissionAccomplished/MissionAccomplishedRect
@onready var MissionAccomplishedAnim = $MissionAccomplished/MissionAccomplishedAnimation
@onready var MissionAccomplishedText = $MissionAccomplished/MissionAccomplishedText

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalInfo.ui = self
	GameOverRect.set_color(Color(0, 0, 0, 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_debuff(id : int, name : String):
	debuffDict[id] = name
	update_text()
	
func remove_debuff(id : int):
	debuffDict.erase(id)
	update_text()
	
func update_text():
	var txt = ""
	for key in debuffDict:
		var debuffName = debuffDict[key]
		txt += debuffName + "\n"
	DebuffList.text = txt
	
func game_over():
	GameOverAnim.play("fade_to_black")
	
func mission_accomplished():
	MissionAccomplishedAnim.play("win_anim")
	

func _on_game_over_animation_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		GameOverText.visible = true


func _on_mission_accomplished_animation_animation_finished(anim_name):
	$YES.play()
	pass
