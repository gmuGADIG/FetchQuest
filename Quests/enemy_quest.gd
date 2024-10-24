extends "res://Quests/quest.gd"

@export var enemies:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quest_ID = 1
	accept_quest()
	enemies = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
