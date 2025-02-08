class_name LockedDoor extends Node2D

enum OpenMethod {
	KEY, ## This door can only be opened by a normal key.
	BOSS_KEY, ## This door can only be opened by a boss key.
	NO_KEY, ## No key will open this door. An activator must open it.
}

@export var relockable := false
@export var open_method := OpenMethod.KEY

@onready var lock_sprite: Sprite2D = %LockSprite

static var doors_opened: Array[NodePath]

func _ready() -> void:
	if doors_opened.has(get_path()):
		unlock()

func activate() -> void:
	unlock()

func deactivate() -> void:
	lock()

func lock() -> void:
	if not relockable: return
	visible = true
	lock_sprite.visible = true
	process_mode = PROCESS_MODE_INHERIT

func unlock() -> void:
	visible = false
	lock_sprite.visible = false
	process_mode = PROCESS_MODE_DISABLED

func _on_area_2d_body_entered(body: Node2D) -> void:
	if _is_opened(): return # for some reason, the Area2D still processes when it shouldn't
	if open_method == OpenMethod.NO_KEY: return
	if not body is Player: return

	if PlayerInventory.use_door_key(open_method == OpenMethod.BOSS_KEY):
		unlock()
		doors_opened.append(get_path())

func _is_opened() -> bool:
	return process_mode == PROCESS_MODE_DISABLED
