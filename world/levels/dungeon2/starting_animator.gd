extends Area2D

@onready var first_point: Node2D = get_node("0");
@onready var second_point: Node2D = get_node("1");
@onready var frog_point: Node2D = $FrogPos;
@onready var frog_boss: FrogBoss = %FrogBoss

func _on_body_entered(body:Node2D) -> void:
	if body is not Player: return

	DJMusicMan.play_music(DJMusicMan.Music.None)

	var player := Player.instance
	player.input_locked = true

	var tween := create_tween()
	var t := player.global_position.distance_to(first_point.global_position) / player.move_speed
	tween.tween_property(player, "global_position", first_point.global_position, t)


	player.play_animation("walk_right")
	await tween.finished
	player.play_animation("idle_right")
	await get_tree().create_timer(.25, false).timeout

	tween = create_tween()
	t = player.global_position.distance_to(second_point.global_position) / player.move_speed
	tween.tween_property(player, "global_position", second_point.global_position, t)
	var starting_zoom := MainCam.instance.zoom
	DJMusicMan.play_music(DJMusicMan.Music.FrogBoss)
	var zoom_tween := create_tween()
	zoom_tween.tween_property(MainCam.instance, "zoom", starting_zoom * .5, 1.5)

	player.play_animation("walk_left")
	await tween.finished
	player.play_animation("idle_left")
	await zoom_tween.finished
	await get_tree().create_timer(1.43 - .5, false).timeout

	tween = create_tween()
	tween.tween_property(frog_boss, "global_position", frog_point.global_position, .125)
	await tween.finished
	MainCam.shake(100, .2)
	await get_tree().create_timer(.125, false).timeout
	MainCam.shake(100, .2)

	tween = create_tween()
	tween.tween_property(MainCam.instance, "zoom", starting_zoom, .125)
	await tween.finished
	await get_tree().create_timer(.5, false).timeout
	

	player.input_locked = false
	frog_boss.activate()


