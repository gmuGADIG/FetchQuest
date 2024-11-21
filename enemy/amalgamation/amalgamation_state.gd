extends Node
class_name AmalgamationState

## Emitted when leaving the state 
signal state_transition

## The amalgamation
@onready var amalgamation:Amalgamation = get_parent().get_parent()

func enter() -> void:
	pass

func update(_delta:float) -> void:
	pass

func exit() -> void:
	pass
