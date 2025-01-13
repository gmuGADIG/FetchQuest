class_name KingWhistleState extends KingState

## The shockwave that is spawned by the king
var shockwave_scene:PackedScene = preload("res://enemy/king_boss/king_shockwave.tscn")
func enter() -> void:
	# Wait until the king teleports to start shockwaves
	await king.teleport_timer.timeout
	# Spawn the shockwaves with a delay between them
	for i in range(king.total_shockwaves):
		king.animated_sprite.play("shockwave")
		spawn_shockwave(king.global_position)
		await get_tree().create_timer(king.time_between_shockwaves).timeout
	
	# Switch to idle
	state_machine.change_state(self, "Idle")

func spawn_shockwave(location:Vector2) -> void:
	# Spawn a shockwave
	var shockwave := shockwave_scene.instantiate()
	shockwave.global_position = location
	king.add_sibling(shockwave)
