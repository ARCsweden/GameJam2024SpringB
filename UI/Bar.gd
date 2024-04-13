extends TextureProgressBar

@onready var timer = $Timer
@onready var damage_Bar = $Damage

var attrib = 0 : set = _set_attrib

func _set_attrib(new_attrib):
	var prev_attrib = attrib
	attrib = new_attrib
	value = attrib
	
	if attrib < prev_attrib:
		timer.start()
	else:
		damage_Bar.value = attrib

func init_attrib(_value, _max):
	attrib = _value
	value = attrib
	max_value = _max
	damage_Bar.max_value = _max
	damage_Bar.value = attrib

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	damage_Bar.value = attrib
