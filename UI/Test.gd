extends HSlider

@onready var display = %Value
@onready var test = $"../ProgressBar"
@onready var display2 = %Value2

func _ready():
	display.init_attrib(100, 100)
	display2.init_attrib(100, 100)


func _on_value_changed(select):
	display.attrib = select
	display2.attrib = select
