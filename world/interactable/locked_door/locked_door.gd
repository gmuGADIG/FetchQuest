class_name LockedDoor extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if PlayerInventory.use_door_key():
			queue_free()
