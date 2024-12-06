extends Node2D

@onready var button_major_sound: AudioStream = preload("res://ui/sounds/SFX UI Bonk 1.wav")
@onready var audio_player: AudioStreamPlayer = $SkinSelectorAudioPlayer

func _skin1_pressed() -> void:
	ChosenSkin.chosen_skin= 1
	await audio_player.finished
	load_game()

func _skin2_pressed() -> void:
	ChosenSkin.chosen_skin = 2
	await audio_player.finished
	load_game()

func _skin3_pressed() -> void:
	ChosenSkin.chosen_skin = 3
	await audio_player.finished
	load_game()
	
func load_game() -> void:
	get_tree().change_scene_to_file("res://world/latest_demo_2.tscn")

func _on_menu_major_button_pressed() -> void:
	audio_player.stream = button_major_sound
	audio_player.play(0.0)
