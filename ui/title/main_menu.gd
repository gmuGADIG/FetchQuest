extends CanvasLayer

func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://world/latest_demo_2.tscn")
	pass # Replace with function body.


func _on_continue_game_pressed() -> void:
	pass # Replace with function body.
