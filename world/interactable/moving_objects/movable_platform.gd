class_name MovablePlatform extends Node2D
## A platform which transfers its motion and rotation
## to everything standing on it.

@onready var _area_2d: Area2D = $Area2D

func _process(delta: float) -> void:
	var last_position := global_position
	var last_rotation := global_rotation
	var fn := func()->void:
		var position_change := global_position - last_position
		var rotation_change := global_rotation - last_rotation
		_move_carried_nodes(position_change, rotation_change)
	fn.call_deferred()

func _move_carried_nodes(movement: Vector2, rotation_change: float) -> void:
	for body in _area_2d.get_overlapping_bodies():
		body.global_position += movement
		body.global_position = (body.global_position - self.global_position).rotated(rotation_change) + self.global_position
