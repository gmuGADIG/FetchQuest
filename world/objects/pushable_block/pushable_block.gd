extends CharacterBody2D

@export var push_unit: float = 155.0
@export_flags_2d_physics var pushing_collision_mask: int = 3

static var pushed_block: Node2D = null
static var push_time: int = 0
static var push_velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:	
	if pushed_block != self and pushed_block != null:
		return
	
	# Update push velocity; search for overlapping player bodies that would exert a force
	# Blocks can only be pushed when not already moving, forcing them to be moved certain distances at a time
	if velocity.length() <= 0:	
		var overlapping_bodies: Array[Node2D] = $Area2D.get_overlapping_bodies()
		for body in overlapping_bodies:
			var player := body as Player
			if player != null:
				# Player found; get a pushing force from their velocity
				var push_direction: Vector2 = player.velocity.normalized()
				
				# Force the block to move in a cardinal direction by 
				# zeroing out the lesser component of its velocity
				if abs(push_direction.x) > abs(push_direction.y):
					push_direction.y = 0;
				else:
					push_direction.x = 0;
				
				# Push velocity isn't changed if the push force points towards the player (And thus, not the block)
				# Prevents issues with the block being sticky and getting pushed when the player moves away
				var direction_to_player: Vector2 = position.direction_to(player.position)			
				if direction_to_player.dot(push_direction) < -0.7:

					# Finally, before moving, validate there is space for the block to move
					if validate_movespace(push_direction.normalized() * push_unit):
						
						# Set push velocity and disable static mode
						push_velocity = push_direction * push_unit / 10.5
						pushed_block = self # Prevent other blocks from moving
						push_time = 20 # block will move for 20 updates
	
	# Move based on push velocity and remaining push_time
	# Total movement equates out to 10.5 times the set push_velocity based on this formula
	velocity = push_velocity * 0.05 * push_time / delta

	push_time = push_time - 1
	if push_time <= 0: # Make the block come to a complete stop and make it static
		velocity = Vector2.ZERO
		pushed_block = null # Allow another block to move
	
	move_and_slide()

# Plots out the block's movement before it happens and confirms there are no other objects in the way
func validate_movespace(movement: Vector2) -> bool:
	
	collision_mask = pushing_collision_mask # Allows proper collision for move_and_collide
	
	var collision: KinematicCollision2D = move_and_collide(movement, true)
	
	collision_mask = 0 # Reset collision masking
	
	return collision == null
