class_name KingWhistleState extends KingState

var shockwave_scene:PackedScene = preload("res://enemy/king_boss/king_shockwave.tscn")
func enter() -> void:
	for i in range(king.total_shockwaves):
		spawn_shockwave(king.global_position)
		await get_tree().create_timer(king.time_between_shockwaves).timeout

	if state_machine.current_state == self:
		state_machine.change_state(self, "Idle")

func update(_delta:float) -> void:
	pass

func exit() -> void:
	pass

func spawn_shockwave(location:Vector2) -> void:
	var shockwave := shockwave_scene.instantiate()
	shockwave.global_position = location
	king.add_sibling(shockwave)
