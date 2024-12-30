extends CanvasLayer

func _ready() -> void:
	$Control/Skin2.grab_focus()

func _skin1_pressed() -> void:
	ChosenSkin.chosen_skin = 1
	SFXManager.bonk_sound.play()
	load_game()

func _skin2_pressed() -> void:
	ChosenSkin.chosen_skin = 2
	SFXManager.bonk_sound.play()
	load_game()

func _skin3_pressed() -> void:
	ChosenSkin.chosen_skin = 3
	SFXManager.bonk_sound.play()
	load_game()
	
func load_game() -> void:
	EntryPoints.current_entry_point = "Entrance"
	SceneTransition.change_scene(preload("res://world/levels/overworld/overworld.tscn"))

func _on_menu_major_button_pressed() -> void:
	SFXManager.bonk_sound.play()
