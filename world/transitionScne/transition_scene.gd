class_name transition_scene extends Area2D

var _player: Player
## The scene that you want to transition to, make sure to use the UID. 
@export var scene: String

func _ready() -> void:
	# wait a single frame in case our _ready was called before the player's
	await get_tree().process_frame
	_player = Player.instance
	#make sure there is a scene and a player 
	assert(scene != "n", "The scene to transition to is not assigned!")
	assert(_player != null, "No player exists in the scene!")

func _on_body_entered(body: Node2D) -> void:
	var player := body as Player
	if player != null:
		SceneTransition.change_scene(load(scene))
