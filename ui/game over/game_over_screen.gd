extends Node2D

@onready var button_sound: AudioStream = preload("res://ui/sounds/SFX UI Bonk 1.wav")
@onready var should_quit: bool = false
@onready var should_restart: bool = false

func _ready() -> void:
	$"Restart checkpoint".grab_focus()
	$GameOverAudioPlayer.stop()

#Checks whether a sound is playing, and if it isn't and either the restart or quit button have been clicked, restarts or
#quits depending on which one was pressed
func _process(seconds: float) -> void:
	
	if(!$GameOverAudioPlayer.is_playing()):
		return
		
	if(should_quit):
		get_tree().quit()
	if(should_restart):
		get_tree().change_scene_to_file("res://world/latest_demo_2.tscn")
		
func _on_restart_checkpoint_pressed() -> void:
	_play_button_sound()
	should_restart = true
		
# Button pressed to go restart and contiune to play the game
# TODO: 
#make a current save to load back rather than restart the whole game

func _on_quit_pressed() -> void:
	_play_button_sound()
	should_quit = true
	
# Button pressed to quit the game

func _play_button_sound() -> void:
	$GameOverAudioPlayer.stream = button_sound
	$GameOverAudioPlayer.play()
