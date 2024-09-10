class_name Hitbox extends Area2D

@export var damage: float = 0

func _ready() -> void:
	assert(collision_layer != 0, "Collision layer not set in inspector!")
