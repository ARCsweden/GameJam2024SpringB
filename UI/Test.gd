extends HSlider

@onready var display = %Value
@onready var test = $"../ProgressBar"

func _ready():
	display.init_attrib(100, 100)


func _on_value_changed(select):
	display.attrib = select
	test.value = select
