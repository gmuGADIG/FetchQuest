class_name KingDeadState extends KingState

var start_pos: Vector2

func enter() -> void:
	king.animated_sprite.play("dead")
	start_pos = king.position

	await get_tree().create_timer(2., false).timeout
	CreditsParams.launched_from_title_screen = false
	SceneTransition.change_scene_to_path("res://ui/credits/credits_screen.tscn", true)

func update(delta:float) -> void:
	king.position = start_pos + Vector2(randf_range(-1, 1), randf_range(-1, 1)) * 5

func exit() -> void:
	pass
