extends Node
class_name AmalgamationState

signal state_transition
## The state machine 
@onready var state_machine:AmalgamationStateMachine = get_parent()

func enter() -> void:
	pass

func update(_delta:float) -> void:
	pass

func exit() -> void:
	pass
