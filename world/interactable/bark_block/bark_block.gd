extends CharacterBody2D

@export var push_speed: float = 300.0
@export_flags_2d_physics var pushing_collision_mask: int = 3

func _physics_process(delta: float) -> void:	
	
	if velocity.length() <= 0:	
		collision_mask = 0 # Reset collision masking to prevent the player from forcing the block around
	else:
		collision_mask = pushing_collision_mask # enable collision masking so terrain and stuff stops movemnt
	
	var oldPos: Vector2 = position
	move_and_slide()
	var newPos: Vector2 = position
	
	var last_collision: KinematicCollision2D = get_last_slide_collision()
	if last_collision != null:
		if last_collision.get_collider_id() == Player.instance.get_instance_id():
			velocity = velocity.normalized() * push_speed # tries to force the block to keep moving when the player gets in the way
		else:
			if oldPos.distance_to(newPos) < 1: # Zero out velocity when collisions stop movement
				velocity = Vector2.ZERO

func hurt(damage_event: DamageEvent) -> void: # Needed to avoid Bark throwing errors, as it expects a hurt function
	pass

func stun() -> void:  
	var player := Player.instance
	if player != null:
		
		# Player found; get a pushing based on the position to them
		var push_direction: Vector2 = player.position.direction_to(position)
		
		# Force the block to move in a cardinal direction by 
		# zeroing out the lesser component of its velocity
		if abs(push_direction.x) > abs(push_direction.y):
			push_direction.y = 0;
		else:
			push_direction.x = 0;
		
		velocity = push_direction * push_speed
