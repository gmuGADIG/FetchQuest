# NOTE: This script exists for testing enemy interactions, as well as to
# give an idea how an enemy might be programmed. Once higher quality enemies
# are made, they should be in their own scripts, and this should be ignored.

class_name TestEnemy extends Enemy

var _player: Player

func _ready() -> void:
	# wait a single frame in case our _ready was called before the player's
	super._ready()
	await get_tree().process_frame

	_player = Player.instance
	assert(_player != null, "No player exists in the scene!")

func _physics_process(_delta: float) -> void:
	if _player == null: return

	look_at(_player.global_position)

func _on_hitting_area_body_entered(body: Node2D) -> void:
	var player := body as Player
	if player != null:
		player.hurt(1)
