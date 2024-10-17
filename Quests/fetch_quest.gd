extends "res://Quests/quest.gd"

@export var numberOfCollectables:int

var enemyType:Enemy

var counter:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quest_ID = 1
	accept_quest()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if numberOfCollectables == counter:
		complete_quest()
