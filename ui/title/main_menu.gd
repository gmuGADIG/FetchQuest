extends CanvasLayer

#Variables for sound management (playing a sound when a button is pressed)
@onready var button_major_sound: AudioStream = preload("res://ui/sounds/SFX UI Bonk 1.wav")
@onready var audio_player: AudioStreamPlayer = $TitleScreenAudioPlayer

func _on_quit_pressed() -> void:
	await audio_player.finished
	get_tree().quit()
	
func _on_new_game_pressed() -> void:
	await audio_player.finished
	get_tree().change_scene_to_file("res://ui/skins/skins.tscn")

func _on_continue_game_pressed() -> void:
	await audio_player.finished

#When a major button is pressed, play the respective sound
#Called when a signal is recieved from the respective buttons
func _on_menu_major_button_pressed() -> void:
	audio_player.stream = button_major_sound
	audio_player.play(0.0)
