class_name HittingBox extends Area2D

@export var damage: float = 0

func _ready() -> void:
	assert(collision_layer != 0, "Collision layer not set in inspector!")
	assert(damage != 0, "Hitting box's damage cannot be zero!")
