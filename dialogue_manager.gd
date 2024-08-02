extends Node
@onready var currInteractable: TalkingInteractable = null
@onready var style: DialogicStyle = preload("res://Example Scenes/ExampleDialogueStyleBubble.tres")

func _ready():
	style.prepare()

func set_interactable(interactable: Node2D) -> void:
	currInteractable = interactable
	
func rewindProgress() -> void:
	if currInteractable == null:
		return
	currInteractable.timesPlayed -= 1
	currInteractable.currTimelineIndex -= 1
