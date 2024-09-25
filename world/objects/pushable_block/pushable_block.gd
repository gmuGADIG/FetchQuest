extends CharacterBody2D

@export var move_speed: float = 250.0
@export var push_velocity: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:	
	# Update push velocity; search for overlapping player bodies that would exert a force
	var overlapping_bodies: Array[Node2D] = $Area2D.get_overlapping_bodies()
	for body in overlapping_bodies:
		var player := body as Player
		if player != null:
			# Player found; get a pushing force from their velocity
			var plr_force: Vector2 = player.velocity.normalized()
			
			# Force the block to move in a cardinal direction by 
			# zeroing out the lesser component of its velocity
			if abs(plr_force.x) > abs(plr_force.y):
				plr_force.y = 0;
			else:
				plr_force.x = 0;
			
			# Push velocity isn't changed if the push force points towards the player (And thus, not the block)
			# Prevents issues with the block being sticky and getting pushed when the player moves away
			var to_plr: Vector2 = position.direction_to(player.position)			
			if to_plr.dot(plr_force) < -0.1:
				# Set push velocity
				push_velocity = plr_force.normalized() * move_speed
	
	# Move based on push velocity
	push_velocity *= 0.9 # So the block slows down when not pushed
	velocity = push_velocity
	move_and_slide()
