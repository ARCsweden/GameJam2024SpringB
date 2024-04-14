extends Control

@export var debuffDict = {}
@onready var DebuffList = $DebuffList

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalInfo.ui = self

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
