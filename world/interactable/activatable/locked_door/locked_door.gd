@tool
class_name LockedDoor extends Node2D

enum OpenMethod {
	KEY, ## This door can only be opened by a normal key.
	BOSS_KEY, ## This door can only be opened by a boss key.
	NO_KEY, ## No key will open this door. An activator must open it.
}

@export var relockable := false
@export var open_method := OpenMethod.KEY
@export var default_sprite_used := true:
	set(v):
		default_sprite_used = v
		default_sprite.visible = v

@onready var default_sprite := %DefaultSprite as Sprite2D
@onready var collision_shape := %CollisionShape2D as CollisionShape2D

static var doors_opened: Array[NodePath]

func _ready() -> void:
	default_sprite.visible = default_sprite_used
	if doors_opened.has(get_path()):
		unlock()

func activate() -> void:
	unlock()

func deactivate() -> void:
	lock()

func lock() -> void:
	if not relockable: return
	visible = true
	collision_shape.disabled = false

func unlock() -> void:
	visible = false
	collision_shape.disabled = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if open_method == OpenMethod.NO_KEY: return
	if not body is Player: return

	if PlayerInventory.use_door_key(open_method == OpenMethod.BOSS_KEY):
		unlock()
		doors_opened.append(get_path())
