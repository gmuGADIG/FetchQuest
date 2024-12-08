extends Node2D


@onready var button_major_sound: AudioStream = preload("res://ui/sounds/SFX UI Bonk 1.wav")
@onready var audio_player: AudioStreamPlayer = $GameOverAudioPlayer

func _ready() -> void:
	$"Restart checkpoint".grab_focus()
		
#After the sound the "quit" button should play stops playing (the await .finished part), restarts
func _on_restart_checkpoint_pressed() -> void:
	await audio_player.finished
	EntryPoints.current_entry_point = "Entrance"
	get_tree().change_scene_to_file("res://world/levels/overworld/overworld.tscn")
		
# TODO: 
#make a current save to load back rather than restart the whole game

#After the sound the "quit" button should play stops playing (the await .finished part), quits
func _on_quit_pressed() -> void:
	await audio_player.finished
	get_tree().quit()
	
#When a major button is pressed, play the respective sound
#Called when a signal is recieved from the respective buttons
func _on_menu_major_button_pressed() -> void:
	audio_player.stream = button_major_sound
	audio_player.play(0.0)
