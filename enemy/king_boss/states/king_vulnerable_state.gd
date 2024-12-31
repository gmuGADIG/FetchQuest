class_name KingVulnerableState extends KingState

## The position that the king is moving towards
var target_position:Vector2
## The amount of panic positions reached
var panic_count:int = 0

func enter() -> void:
	# Get a new target and remove the unhittable aura
	target_position = random_move_point(20)
	king.bubble_sprite.visible = false

func update(_delta:float) -> void:
	# Switch to idle if the scepter is found
	if abs(king.global_position.distance_to(king.current_lost_scepter.global_position)) < 10:
		state_machine.change_state(self, "Idle")
	# Get new target when necessary and always move towards
	handle_target_choices()
	move_towards_target()


func exit() -> void:
	# Remove the dropped scepter, reset variables, enable unhittable aura
	king.current_lost_scepter.queue_free()
	king.current_lost_scepter = null
	king.bubble_sprite.visible = true
	panic_count = 0

func handle_target_choices() -> void:
	# Check if lost scepter exists
	# (without it theres a crash and idk how to fix it other than this)
	if king.current_lost_scepter == null:
		return
	# If we have reached the target, get a new point
	if abs(king.global_position.distance_to(target_position)) < 10:
		target_position = random_move_point(king.panic_distance)
		panic_count += 1
	# Move towards the scepter if the king has panicked enough
	if panic_count > king.total_panic_points:
		target_position = king.current_lost_scepter.global_position

func random_move_point(distance:float) -> Vector2:
	# Get a random move point
	return king.global_position + Vector2(randf_range(-1,1), randf_range(-1,1)).normalized() * distance

func move_towards_target() -> void:
	# Set the velocity to be towards the target
	king.velocity = (target_position - king.global_position).normalized() * king.panic_speed
	king.move_and_slide()
