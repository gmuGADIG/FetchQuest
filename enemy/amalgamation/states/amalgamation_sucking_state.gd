class_name AmalgamationSuckingState extends AmalgamationState


func enter() -> void:
	await get_tree().create_timer(10).timeout
	if state_machine.current_state != self:
		return
	state_machine.change_state(self, "Idle")
	pass

func update(_delta:float) -> void:
	pass

func exit() -> void:
	pass


# Called when a bomb enters the mouth of the amalgamation
func _on_mouth_area_body_entered(body: Node2D) -> void:
	if state_machine.current_state != self:
		return

	# Blow up the bomb (body must be bomb due to collision mask)
	body.hurt(DamageEvent.new(0))

	# Switch to vulnerable state
	state_machine.change_state(self, "Vulnerable")
