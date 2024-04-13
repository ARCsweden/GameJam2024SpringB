extends TextEdit

@onready var text_edit = $"."
@onready var boss_dialog = %BossDialog
@onready var rich_text_label = $RichTextLabel


func _on_text_set():
	boss_dialog.dialog = text_edit.text
	rich_text_label.text = text_edit.text
