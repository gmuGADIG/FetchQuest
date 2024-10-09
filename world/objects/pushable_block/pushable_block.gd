extends CharacterBody2D

@export var move_speed: float = 250.0

func _physics_process(_delta: float) -> void:	
	# Update push velocity; search for overlapping player bodies that would exert a force
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
				# Set push velocity
				velocity = push_direction.normalized() * move_speed
	
	# Move based on push velocity
	velocity *= 0.9 # So the block slows down when not pushed
	move_and_slide()
