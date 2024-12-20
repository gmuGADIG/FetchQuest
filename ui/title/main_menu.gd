extends Control

func _on_quit_pressed() -> void:
	get_tree().quit()
	
func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://ui/skins/skins.tscn"))

func _on_continue_game_pressed() -> void:
	pass # TODO: save system

#When a major button is pressed, play the respective sound
#Called when a signal is recieved from the respective buttons
func _on_menu_major_button_pressed() -> void:
	SFXManager.bonk_sound.play()
