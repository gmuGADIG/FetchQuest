extends Area2D
class_name TalkingInteractable

##The Dialogic Timeline to play when interacting
@export var timeline: Array[DialogicTimeline]

##The Dialogic Character being interacted with
@export var character: DialogicCharacter

## If set to true, the interactable will not repeat its dialogue
## after going through all of its timelines.
## Otherwise, the dialogue will repeat on continual interactions.
@export var oneTime: bool = false

@onready var currTimelineIndex: int = 0
@onready var timesPlayed: int = 0
@onready var playerInRange: bool = false
var player: CharacterBody2D

func _ready() -> void:
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	for t in timeline:
		Dialogic.preload_timeline(t)

func _input(event) -> void:
	if Dialogic.current_timeline != null:
		return
	
	if oneTime && timesPlayed > timeline.size()-1:
		return
	
	if playerInRange && event.is_action_pressed("interact"):
		player.inDialogue = true
		DialogueManager.set_interactable(self)
		var layout := Dialogic.start(timeline[currTimelineIndex])
		layout.register_character(character, get_parent())
		get_viewport().set_input_as_handled()

func _on_timeline_ended() -> void:
	player.inDialogue = false
	currTimelineIndex += 1
	currTimelineIndex %= timeline.size()
	timesPlayed += 1

func _on_body_entered(body) -> void:
	if body.name == "Player":
		playerInRange = true
		player = body

func _on_body_exited(body) -> void:
	if body.name == "Player":
		playerInRange = false
