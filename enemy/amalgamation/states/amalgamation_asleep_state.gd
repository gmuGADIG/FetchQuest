class_name AmalgamationAsleepState extends AmalgamationState

## The state machine
@onready var state_machine:AmalgamationStateMachine = get_parent()

func enter() -> void:
	pass

func update(_delta:float) -> void:
	pass

func exit() -> void:
	pass


# Called when a bomb enters the mouth of the amalgamation
func _on_mouth_area_body_entered(body: Node2D) -> void:
	if state_machine.current_state != self:
		return
	
	# Body must be bomb due to collision mask
	body.hurt(DamageEvent.new(0))
	
	# Switch to idle
	state_machine.change_state(self, "Idle")
