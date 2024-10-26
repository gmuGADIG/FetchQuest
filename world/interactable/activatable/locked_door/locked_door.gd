class_name LockedDoor extends Node2D

## Whether or not this locked door can be unlocked with a key.
@export var key_usable := true

# activatable method
func activate() -> void:
	unlock()

# activatable method
func deactivate() -> void:
	pass

func unlock() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not key_usable: return
	if not body is Player: return

	if PlayerInventory.use_door_key():
		unlock()
