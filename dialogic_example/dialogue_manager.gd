extends Node
@onready var curr_interactable: TalkingInteractable = null
@onready var style: DialogicStyle = preload("res://dialogic_example/ExampleDialogueStyleBubble.tres")
@onready var layout: DialogicLayoutBase = null

func _ready() -> void:
	style.prepare()

func set_interactable(interactable: Node2D) -> void:
	curr_interactable = interactable
	
func rewind_progress() -> void:
	if curr_interactable == null:
		return
	curr_interactable.times_played -= 1
	curr_interactable.curr_timeline_index -= 1
