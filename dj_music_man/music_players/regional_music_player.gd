extends Area2D

@export var music_to_play: DJMusicMan.Music

func _on_body_entered(body:Node2D) -> void:
	if body is Player:
		DJMusicMan.play_music(music_to_play)

