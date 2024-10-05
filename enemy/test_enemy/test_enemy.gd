# NOTE: This script exists for testing enemy interactions, as well as to
# give an idea how an enemy might be programmed. Once higher quality enemies
# are made, they should be in their own scripts, and this should be ignored.

class_name TestEnemy extends Enemy



func _ready() -> void:
	# wait a single frame in case our _ready was called before the player's
	await get_tree().process_frame

	_player = Player.instance
	assert(_player != null, "No player exists in the scene!")

func _physics_process(_delta: float) -> void:
	if _player == null: return
	
	else:
		velocity = (_player.global_position - global_position).normalized() * 300
	move_and_slide()

	look_at(_player.global_position)
