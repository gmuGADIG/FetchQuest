extends Node2D



func _skin1_pressed() -> void:
	ChosenSkin.chosen_skin= 1
	load_game()


func _skin2_pressed() -> void:
	ChosenSkin.chosen_skin = 2
	load_game()

func _skin3_pressed() -> void:
	ChosenSkin.chosen_skin = 3
	load_game()
	
func load_game() -> void:
	get_tree().change_scene_to_file("res://world/latest_demo_2.tscn")
