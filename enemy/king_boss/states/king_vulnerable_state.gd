class_name KingVulnerableState extends KingState

## The position that the king is moving towards
var target_position:Vector2
## The amount of panic positions reached
var panic_count:int = 0
## Area2D for checking if the king is touching the terrain
@onready var terrain_checker:Area2D = $"../../TerrainChecker"

func enter() -> void:
	# Get a new target 
	target_position = get_random_move_point(king.panic_distance)

func update(_delta:float) -> void:
	# Play the correct panic animation
	if king.velocity.x > 0:
		king.animated_sprite.play("panic_left")
	else:
		king.animated_sprite.play("panic_right")

	# Switch to idle if the scepter is found
	if abs(king.global_position.distance_to(king.current_lost_scepter.global_position)) < 10:
		state_machine.change_state(self, "Idle")
	
	# Die if health drops to 0
	if king.health <= 0:
		state_machine.change_state(self, "Dead")
	
	# Get new target when necessary and always move towards it
	handle_target_choices()
	move_towards_target()


func exit() -> void:
	# Remove the dropped scepter and reset variables
	king.current_lost_scepter.queue_free()
	king.current_lost_scepter = null
	#king.bubble_sprite.visible = true
	panic_count = 0

func handle_target_choices() -> void:
	# Check if lost scepter exists
	# (without it theres a crash and idk how to fix it other than this)
	if king.current_lost_scepter == null:
		return
	
	# If we have reached the target, get a new random point
	if abs(king.global_position.distance_to(target_position)) < 10:
		target_position = get_random_move_point(king.panic_distance)
		panic_count += 1
	
	# Move towards the center if king gets too close to a wall
	if terrain_checker.has_overlapping_bodies():
		var direction_to_center:Vector2 = king.global_position.direction_to(king.room_center.global_position)
		target_position = king.global_position + (direction_to_center * king.panic_distance)
		panic_count += 1
	
	# Move towards the scepter if the king has panicked enough
	if panic_count > king.total_panic_points:
		target_position = king.current_lost_scepter.global_position

func get_random_move_point(distance:float) -> Vector2:
	# Get a random move point
	return king.global_position + random_direction() * distance

func random_direction() -> Vector2:
	# Get a random direction
	return Vector2(randf_range(-1,1), randf_range(-.25,.25)).normalized()

func move_towards_target() -> void:
	# Set the velocity to be towards the target
	king.velocity = (target_position - king.global_position).normalized() * king.panic_speed
	king.move_and_slide()
