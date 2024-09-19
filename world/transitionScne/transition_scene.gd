class_name transition_scene extends Area2D

var _player: Player
@export var scene: PackedScene

func _ready() -> void:
	# wait a single frame in case our _ready was called before the player's
	await get_tree().process_frame

	_player = Player.instance
	assert(_player != null, "No player exists in the scene!")

func _on_body_entered(body: Node2D) -> void:
	var player := body as Player
	if player != null:
		get_tree().change_scene_to_packed(scene)
