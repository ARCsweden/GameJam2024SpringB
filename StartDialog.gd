extends RichTextLabel

@onready var boss_dialog = $"."
@onready var timer = $TimerCharacter
@onready var timeout = $Timeout

var dialog = "" : set = _set_dialog
var characters

func _set_dialog(new_text):
	boss_dialog.visible_characters = 0
	characters = new_text.length()
	boss_dialog.text = new_text
	
	if characters > 0:
		timer.start()
		boss_dialog.visible = true
		pass
	else:
		boss_dialog.visible = false
		pass
		


func _on_timer_timeout():
	boss_dialog.visible_characters = boss_dialog.visible_characters + 1
	timeout.stop()
	timer.stop()
	
	if boss_dialog.visible_characters < characters:
		timer.start()
	else:
		timeout.start()


func _on_timeout_timeout():
	boss_dialog.visible = false
	get_tree().change_scene_to_file("res://game.tscn")
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	dialog = "KIM wanted to be a karate master - but could not split wood.
Ridiculed, KIM vowed to one day split ANYTHING.

Having mastered SPLITTING KIM proved their power by SPLITTING A MARRIAGE IN TWO.
The now divorced HUSBAND canceled his round of golf to exact his revenge...!"
