extends Node
class_name AmalgamationStateMachine

var states:Dictionary = {}
@export var initial_state:AmalgamationState
var current_state:AmalgamationState
func _ready() -> void:
	for state in get_children():
		if state is AmalgamationState:
			states[state.name.to_lower()] = state

	current_state = initial_state
	current_state.enter()

func _physics_process(delta: float) -> void:
	current_state.update(delta)

func change_state(source_state: AmalgamationState, desired_state_name: String) -> void:
	if current_state != source_state:
		printerr("Error! Trying to change from " + source_state.name + " while in " + current_state.name)
		return

	var desired_state: AmalgamationState = states[desired_state_name.to_lower()]
	if !desired_state:
		printerr("Error! State \""+ desired_state_name + "\" does not exist ")
		return
	current_state.exit()
	current_state = desired_state
	current_state.enter()

	print("Success! Changed from " + source_state.name + " to " + desired_state_name)
