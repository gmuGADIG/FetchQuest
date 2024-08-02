extends Area2D
@export var timeline: DialogicTimeline
@export var oneTime: bool = false
@onready var timesPlayed: int = 0
@onready var playerInRange: bool = false
var player: CharacterBody2D
func _ready() -> void:
	Dialogic.timeline_ended.connect(_on_timeline_ended)

func _input(event) -> void:
	if Dialogic.current_timeline != null:
		return
	
	if oneTime && timesPlayed > 0:
		return
	
	if playerInRange && event.is_action_pressed("interact"):
		player.inDialogue = true
		Dialogic.start(timeline)
		get_viewport().set_input_as_handled()

func _on_timeline_ended() -> void:
	player.inDialogue = false
	timesPlayed += 1

func _on_body_entered(body) -> void:
	if body.name == "Player":
		playerInRange = true
		player = body

func _on_body_exited(body) -> void:
	if body.name == "Player":
		playerInRange = false
