extends Area2D

@export var music_to_play: DJMusicMan.Music

func _on_body_entered(body:Node2D) -> void:
	if body is Player:
		DJMusicMan.play_music(music_to_play)

func _on_other_body_exited() -> void:
	if not get_overlapping_bodies().filter(func(b: Node2D) -> bool: return b is Player).is_empty():
		DJMusicMan.play_music(music_to_play)


func _on_body_exited(body: Node2D) -> void:
	await get_tree().physics_frame
	for music_player in get_tree().get_nodes_in_group("RegionalMusicPlayer"):
		music_player._on_other_body_exited()
