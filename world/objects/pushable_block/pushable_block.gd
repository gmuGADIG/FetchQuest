extends CharacterBody2D

@export var push_unit: float = 1000.0

func _physics_process(delta: float) -> void:	
	
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
					# Ready to move
					push_direction = push_direction.normalized() * push_unit
					
					# Finally, before moving, validate there is space for the block to move
					if validate_movespace(push_direction):
						# Set push velocity
						velocity = push_direction
	
	# Move based on push velocity
	velocity *= 0.9 # So the block slows down when not pushed
	
	if velocity.length() < 10: # Make the block come to a complete stop
		velocity = Vector2.ZERO
	
	move_and_slide()

# Plots out the block's movement before it happens and confirms there are no other objects in the way
func validate_movespace(start_velocity: Vector2) -> bool:
	
	var start_position: Vector2 = position # So position can be reset afterwards
	
	while start_velocity.length() > 10:
		
		start_velocity *= 0.9
		
		velocity = start_velocity
		
		var collision: bool = move_and_slide()
		
		if collision:
			position = start_position # Reset the position so it doesn't actually move
			velocity = Vector2.ZERO
			return false
	
	position = start_position # Reset the position so it doesn't actually move
	velocity = Vector2.ZERO
	return true
