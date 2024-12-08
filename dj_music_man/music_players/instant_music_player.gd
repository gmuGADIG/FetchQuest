class_name MusicPlayer extends Node

@export var music_to_play: DJMusicMan.Music

func _ready() -> void:
	DJMusicMan.play_music(music_to_play)
