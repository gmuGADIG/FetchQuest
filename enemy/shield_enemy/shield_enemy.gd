class_name ShieldEnemy extends Enemy
@export var movement_speed:float = 300
@export var shield_size:float = 60
func _ready() -> void:
	# wait a single frame in case our _ready was called before the player's
	await get_tree().process_frame

func _physics_process(_delta: float) -> void:
	if Player.instance == null: return

	else:
		var move_direction := (Player.instance.global_position - global_position).normalized()
		velocity = move_direction * movement_speed
		look_at(Player.instance.global_position)
	move_and_slide()
	
func _on_shield_body_entered(body: Node2D) -> void:
	var angle_to_body:float = rad_to_deg(get_angle_to(body.global_position))

	if body is ThrownSword:
		if (-shield_size / 2) < angle_to_body and angle_to_body < (shield_size / 2):
			print("shield_enemy.gd: hit shield")
			body.return_sword()
	# if body is bomb:
		# let bomb through
