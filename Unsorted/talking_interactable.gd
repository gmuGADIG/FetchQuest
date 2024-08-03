extends Area2D
class_name TalkingInteractable

##The Dialogic Timeline to play when interacting
@export var timeline: Array[DialogicTimeline]

##The Dialogic Character being interacted with
@export var character: DialogicCharacter = null

## If set to true, the interactable will not repeat its dialogue
## after going through all of its timelines.
## Otherwise, the dialogue will repeat on continual interactions.
@export var oneTime: bool = false

@onready var currTimelineIndex: int = 0
@onready var timesPlayed: int = 0
@onready var playerInRange: bool = false
var player: CharacterBody2D

func _ready() -> void:
	Dialogic.timeline_started.connect(_on_timeline_started)
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	for t in timeline:
		Dialogic.preload_timeline(t)
	if character == null:
		push_warning("The dialogic character for " + get_parent().name + "has not been assigned.")

func _input(event) -> void:
	if Dialogic.current_timeline != null:
		return
	
	if not is_active():
		return
	
	if playerInRange && event.is_action_pressed("interact"):
		player.inDialogue = true #Prevent player movement
		DialogueManager.set_interactable(self) #Give the Dialogue Manager access to the interactable
		DialogueManager.layout = Dialogic.start(timeline[currTimelineIndex])
		get_viewport().set_input_as_handled()

func _on_timeline_started() -> void:
	#This assigns the Dialogic character to the Node in the Scene
	#so that Dialogue knows where to show the text bubble.
	#This should be able to allow for dialogue scenes with multiple talking npcs
	#at once.
	if DialogueManager.layout.has_method("register_character") && character != null:
		DialogueManager.layout.register_character(character, get_parent())

func _on_timeline_ended() -> void:
	player.inDialogue = false
	currTimelineIndex += 1
	currTimelineIndex %= timeline.size()
	timesPlayed += 1
	if not is_active():
		player.canInteract = false

func _on_body_entered(body) -> void:
	if body.name == "Player":
		playerInRange = true
		player = body
		if is_active():
			body.canInteract = true

func _on_body_exited(body) -> void:
	if body.name == "Player":
		body.canInteract = false
		playerInRange = false

#Returns true if the interactable still has more dialogue
func is_active() -> bool:
	return not (oneTime && timesPlayed > timeline.size()-1)
