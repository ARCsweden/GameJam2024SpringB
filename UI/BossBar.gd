extends CanvasLayer

@onready var boss_hp = %BossHp

var attrib = 0 : set = _set_attrib
var attrib_max = 0 : set = _set_attrib_max

func _set_attrib(new_attrib):
	boss_hp._set_attrib(new_attrib)

func _set_attrib_max(max_attrib):
	boss_hp._set_attrib_max(max_attrib)
	
func _ready():
	GlobalInfo.Boss_Bar = self
