extends Node2D
signal fall_in_hole

@onready var close_to_hole_area: Area2D = $CloseToHole
@onready var hole_area: Area2D = $InHole
@onready var last_safe_position := global_position

@export var points: Array[Node2D]
var enabled := true

func hole_pointcast(point: Vector2) -> bool:
	var params := PhysicsPointQueryParameters2D.new()
	params.position = point
	params.collision_mask = 8 # hole layer

	var results := get_world_2d().direct_space_state.intersect_point(params)

	return not results.is_empty()

func _process(delta: float) -> void:
	if not enabled: return
	
	if close_to_hole_area.get_overlapping_bodies().is_empty():
		last_safe_position = global_position

	var raycast := true
	for point in points:
		raycast = raycast and hole_pointcast(point.global_position)
	raycast = raycast and hole_pointcast(hole_area.global_position)

	if _has_unoccluded_hole(hole_area.get_overlapping_bodies()) and raycast:
		fall_in_hole.emit()

static func _has_unoccluded_hole(collisions: Array[Node2D]) -> bool:
	if collisions.is_empty():
		return false # not colliding with a hole
	else:
		for body in collisions:
			if body.is_in_group("HoleOccluder"):
				return false # colliding with an occluded hole
		return not collisions.is_empty() # unoccluded hole
