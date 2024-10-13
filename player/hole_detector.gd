extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not monitoring: return
	var overlaps := get_overlapping_bodies()

	# if not overlapping anything, do nothing
	if overlaps.size() == 0: return

	# if we're overlapping a hole occluder, do nothing
	for body in overlaps:
		if body.is_in_group("HoleOccluder"):
			return
	
	# otherwise, make the player fall into a hole
	player_fall(overlaps[0])
	
func player_fall(hole: Node2D) -> void:
	Player.instance.hurt(DamageEvent.new(1))
	Player.instance.position -= Player.instance.global_position.direction_to(hole.global_position) * 200
