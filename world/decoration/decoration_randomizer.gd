extends Node2D

@export_range(0, 1) var scale_randomness := 0.1
@export var can_flip := true

func _ready() -> void:
	scale *= 1 + randf_range(-scale_randomness, +scale_randomness)
	if can_flip and randf() > 0.5: scale.x *= -1
