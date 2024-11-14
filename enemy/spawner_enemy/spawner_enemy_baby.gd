extends Enemy

@export var attack_radius: float = 30

## Should not be set in the inspector. Used by animations to perform the attack.
@export var attack_enabled: bool = false

func _process(delta: float) -> void:
	super._process(delta)
	
	var distance_to_player := global_position.distance_to(Player.instance.global_position)
	if distance_to_player < agressive_target_distance_max:
		if enemy_state == EnemyState.ROAMING:
			enemy_state = EnemyState.AGRESSIVE
	else:
		if enemy_state == EnemyState.AGRESSIVE:
			enemy_state = EnemyState.ROAMING

func _process_agressive(delta: float) -> void:
	# Approach the player, then do the attack animation.
	approach(Player.instance.global_position)
	
	if global_position.distance_to(Player.instance.global_position) < attack_radius:
		$AnimationPlayer.play("attack")
		
# Override the contact damage function, and only allow it through during the
# attack. This doesn't work due to signals being the worst.
#func _on_hitting_area_body_entered(body: Node2D) -> void:
	#if attack_enabled:
		#super(body)
		
