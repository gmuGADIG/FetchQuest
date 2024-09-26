extends "res://Quests/quest.gd"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quest_ID = 0
	accept_quest()
	quest_name = "Cat Chase"
	quest_description = "Defeat the cats in the area"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
