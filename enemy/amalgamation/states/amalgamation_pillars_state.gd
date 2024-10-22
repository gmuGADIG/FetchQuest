class_name AmalgamationPillarsState extends AmalgamationState


func enter() -> void:
	# Placeholder for testing
	await get_tree().create_timer(1).timeout
	state_machine.change_state(self, "Idle")

func update(_delta:float) -> void:
	pass

func exit() -> void:
	pass
