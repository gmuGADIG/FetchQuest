class_name LockedDoor extends Node2D

## Whether or not this locked door can be unlocked with a key.
@export var key_usable := true

static var doors_opened: Array[NodePath]

func _ready() -> void:
	if doors_opened.has(get_path()):
		unlock()

func activate() -> void:
	unlock()

func unlock() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not key_usable: return
	if not body is Player: return

	if PlayerInventory.use_door_key():
		unlock()
		doors_opened.append(get_path())
