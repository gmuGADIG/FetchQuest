extends Node2D


func _on_restart_checkpoint_pressed() -> void:
	get_tree().change_scene_to_file("res://world/latest_demo.tscn")




func _on_quit_pressed() -> void:
	get_tree().quit()
