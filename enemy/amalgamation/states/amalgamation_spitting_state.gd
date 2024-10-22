class_name AmalgamationSpittingState extends AmalgamationState


func enter() -> void:
	# Placeholder for testing
	await get_tree().create_timer(4).timeout
	if state_machine.current_state != self:
		return
	state_machine.change_state(self, "Idle")
	
func update(_delta:float) -> void:
	pass

func exit() -> void:
	pass
