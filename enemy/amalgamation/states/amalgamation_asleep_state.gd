class_name AmalgamationAsleepState extends AmalgamationState


func enter() -> void:
	print("amalgamation_asleep_state.gd: Honk shoooooo mimimimimimimimimi")
	amalgamation.animation_player.play("Sleeping")

func update(_delta:float) -> void:
	pass

func exit() -> void:
	pass


# Called when a bomb or player enters the mouth of the amalgamation
func _on_mouth_area_body_entered(body: Node2D) -> void:
	if amalgamation.state_machine.current_state != self:
		return
	if body is not Bomb:
		return
	#TODO maybe move the bomb into the mouth
	
	# Get the bomb timer and wait until it ends
	for child in body.get_children():
		if child is Timer:
			await child.timeout
			break
	
	# Switch to idle
	if amalgamation.state_machine.current_state == self:
		amalgamation.state_machine.change_state(self, "Idle")
