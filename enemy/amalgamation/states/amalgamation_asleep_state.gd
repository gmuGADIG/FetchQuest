class_name AmalgamationAsleepState extends AmalgamationState


func enter() -> void:
	print("amalgamation_asleep_state.gd: Honk shoooooo mimimimimimimimimi")

func update(_delta:float) -> void:
	pass

func exit() -> void:
	pass


# Called when a bomb or player enters the mouth of the amalgamation
func _on_mouth_area_body_entered(body: Node2D) -> void:
	if amalgamation.state_machine.current_state != self:
		return
	if body is Player or body is ThrownSword:
		return
	
	# Blow up the bomb (body must be bomb due to collision mask)
	body.hurt(DamageEvent.new(0))
	
	# Switch to idle
	amalgamation.state_machine.change_state(self, "Idle")
