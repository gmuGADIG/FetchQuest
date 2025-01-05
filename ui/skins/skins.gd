class_name Skins extends CanvasLayer

static var chosen_skin := 1

func _skin1_pressed() -> void:
	chosen_skin = 1
	SFXManager.bonk_sound.play()
	load_game()

func _skin2_pressed() -> void:
	chosen_skin = 2
	SFXManager.bonk_sound.play()
	load_game()

func _skin3_pressed() -> void:
	chosen_skin = 3
	SFXManager.bonk_sound.play()
	load_game()
	
func load_game() -> void:
	EntryPoints.current_entry_point = "Entrance"
	SceneTransition.change_scene(SceneManager.get_packed_scene("overworld"))

func _on_menu_major_button_pressed() -> void:
	SFXManager.bonk_sound.play()
