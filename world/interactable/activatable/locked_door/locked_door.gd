class_name LockedDoor extends Node2D

enum OpenMethod {
	KEY, ## This door can only be opened by a normal key.
	BOSS_KEY, ## This door can only be opened by a boss key.
	NO_KEY, ## No key will open this door. An activator must open it.
}

@export var open_method := OpenMethod.KEY

static var doors_opened: Array[NodePath]

func _ready() -> void:
	if doors_opened.has(get_path()):
		unlock()

func activate() -> void:
	unlock()

func unlock() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if open_method == OpenMethod.NO_KEY: return
	if not body is Player: return

	if PlayerInventory.use_door_key(open_method == OpenMethod.BOSS_KEY):
		unlock()
		doors_opened.append(get_path())
