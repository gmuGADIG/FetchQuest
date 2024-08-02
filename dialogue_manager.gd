extends Node
@onready var currInteractable: TalkingInteractable = null

func set_interactable(interactable: Node2D) -> void:
	currInteractable = interactable
	
func rewindProgress() -> void:
	if currInteractable == null:
		return
	currInteractable.timesPlayed -= 1
	currInteractable.currTimelineIndex -= 1
