extends "res://Quests/quest.gd"

var enemies:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quest_ID = 1
	quest_accept = false
	quest_complete = false
	quest_name = "Cat Chase"
	quest_description = "Defeat the cats in the area"
	enemies = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
