extends CanvasLayer

func _ready() -> void:
	$Panel/NewGame.grab_focus()
	$OptionsMenu.option_menu_hidden.connect(self._on_option_menu_hidden)

	%ContinueGame.disabled = not SaveSystem.save_valid()
	
	# start loading overworld right away, because it can take a second
	#ResourceLoader.load_threaded_request(SceneManager.get_scene_path("overworld"))
	
func _on_quit_pressed() -> void:
	get_tree().quit()
	
func _on_new_game_pressed() -> void:
	SaveSystem.new_game()
	get_tree().change_scene_to_packed(preload("res://ui/skins/skins.tscn"))

func _on_continue_game_pressed() -> void:
	SaveSystem.load_game()
	pass # TODO: save system
	
func _on_option_menu_hidden() -> void:
	$Panel/Options.grab_focus()

#When a major button is pressed, play the respective sound
#Called when a signal is recieved from the respective buttons
func _on_menu_major_button_pressed() -> void:
	SFXManager.bonk_sound.play()


func _on_credits_pressed() -> void:
	SceneTransition.change_scene_to_path("ui/credits/credits_screen.tscn")
