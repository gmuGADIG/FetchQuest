extends Node
@onready var currInteractable: TalkingInteractable = null
@onready var style: DialogicStyle = preload("uid://cv8koh10fgjyq")
@onready var layout: DialogicLayoutBase = null

func _ready() -> void:
	style.prepare()

func set_interactable(interactable: Node2D) -> void:
	currInteractable = interactable
	
func rewindProgress() -> void:
	if currInteractable == null:
		return
	currInteractable.timesPlayed -= 1
	currInteractable.currTimelineIndex -= 1
