class_name DestroyOnLoad extends Node

func _ready() -> void:
	get_parent().queue_free()
