class_name ShieldEnemy extends Enemy

# TODO: make this use the base enemy state machine

func _ready() -> void:
	# Wait a single frame in case our _ready was called before the player's
	await get_tree().process_frame

func _physics_process(_delta: float) -> void:
	if Player.instance == null: 
		return

	# Move towards and look at the player 
	var direction := global_position.direction_to(Player.instance.global_position)
	velocity = direction * 300 #movement speed
	$Shield.rotation = direction.angle()
	# look_at(Player.instance.global_position)
	move_and_slide()

	$AnimatedSprite2D.flip_h = direction.x > 0
