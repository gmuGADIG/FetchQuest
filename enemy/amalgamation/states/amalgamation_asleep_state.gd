class_name AmalgamationAsleepState extends AmalgamationState


func enter() -> void:
	# Wait until all values are set (it takes one frame)
	await get_tree().process_frame
	
	# Play animation
	amalgamation.anim_sprite.play("sleeping")
	
	print("amalgamation_asleep_state.gd: Honk shoooooo mimimimimimimimimi")

func update(_delta:float) -> void:
	# while sleeping, all bombs are sucked into the mouth
	for body:Node2D in %SuckingArea.get_overlapping_bodies():
		if body is not Bomb: continue
		
		var direction_to_mouth:Vector2 = body.global_position.direction_to(%SuckingArea.global_position)
		body.position += direction_to_mouth * _delta * amalgamation.sucking_speed

func exit() -> void:
	pass


# Called when a bomb or player enters the mouth of the amalgamation
func _on_mouth_area_body_entered(body: Node2D) -> void:
	if amalgamation.state_machine.current_state != self:
		return
	if body is not Bomb:
		return
			
	# Get the bomb timer and wait until it ends
	for child in body.get_children():
		if child is Timer:
			await child.timeout
			break
	
	# Switch to idle
	if amalgamation.state_machine.current_state == self:
		%SleepingParticles.emitting = false
		amalgamation.state_machine.change_state(self, "Idle")
