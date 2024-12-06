extends Node
class_name AmalgamationStateMachine

## The possible states
var states:Dictionary = {}

## The state that the machine will begin with
@export var initial_state:AmalgamationState

## The state that the machine is currently in
var current_state:AmalgamationState

func _ready() -> void:
	# Get the states (they are children of the statemachine)
	for state in get_children():
		if state is AmalgamationState:
			states[state.name.to_lower()] = state
	
	# Set the current state and enter it
	current_state = initial_state
	current_state.enter()

func _physics_process(delta: float) -> void:
	# Update the state
	current_state.update(delta)

func change_state(source_state: AmalgamationState, desired_state_name: String) -> void:
	# Ensure the current state is what we are trying to switch from
	if current_state != source_state:
		printerr("amalgamation_state_machine.gd: Error! Trying to change from " + source_state.name + " while in " + current_state.name)
		return
	
	# Ensure the state exists
	var desired_state: AmalgamationState = states[desired_state_name.to_lower()]
	if !desired_state:
		printerr("amalgamation_state_machine.gd: Error! State \""+ desired_state_name + "\" does not exist ")
		return
	
	# Switch states
	current_state.exit()
	current_state.state_transition.emit()
	current_state = desired_state
	current_state.enter()

	#print("amalgamation_state_machine.gd: Success! Changed from " + source_state.name + " to " + desired_state_name)
