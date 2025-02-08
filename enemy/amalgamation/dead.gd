class_name AmalgamationDeadState extends AmalgamationState

var start_pos: Vector2
func enter() -> void:
	amalgamation.anim_sprite.play("pillar_loop")
	start_pos = amalgamation.position

	await get_tree().create_timer(2., false).timeout
	EntryPoints.current_entry_point = "ThicketDungeon"
	SceneTransition.change_scene(SceneManager.get_packed_scene("overworld"), true)

var clock := 0.0
func update(delta:float) -> void:
	clock = fmod(clock + delta * 5., 1.)
	amalgamation.position = start_pos + (Vector2(100, 0) * signf(clock - .5))

func exit() -> void:
	pass
