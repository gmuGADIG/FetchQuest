extends Node

func _ready() -> void:
	# wait a frame for good measure
	await get_tree().process_frame
	SaveSystem.save_game()
