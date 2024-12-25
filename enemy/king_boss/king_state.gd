extends Node
class_name KingState

## Emitted when leaving the state 
signal state_transition

## The King
@onready var king:King = get_parent().get_parent()

func enter() -> void:
	pass

func update(_delta:float) -> void:
	pass

func exit() -> void:
	pass
