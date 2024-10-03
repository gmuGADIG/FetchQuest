extends Node2D

func _ready() -> void:
	$"Restart checkpoint".grab_focus()


func _on_restart_checkpoint_pressed() -> void:
	get_tree().change_scene_to_file("uid://3sqp1m0iowsi")
# Button pressed to go restart and contiune to play the game
# TODO: 
#make a current save to load back rather than restart the whole game



func _on_quit_pressed() -> void:
	get_tree().quit()
# Button pressed to quit the game
