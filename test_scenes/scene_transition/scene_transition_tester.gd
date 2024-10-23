extends Control

func _on_button_pressed() -> void:
	SceneTransition.change_scene(preload("res://world/latest_demo_2.tscn"))
