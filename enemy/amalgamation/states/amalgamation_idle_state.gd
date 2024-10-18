class_name AmalgamationIdleState extends AmalgamationState
## The state machine 
@onready var state_machine:AmalgamationStateMachine = get_parent()

## The states that are considered attacking states 
@export var attack_states:Array[AmalgamationState]
## The weights of each attack state being chosen (in order of the attack_states array)
@export var attack_state_weights:Array[float] = [.33,.33,.33];

## The next state amalgamation will be in once ready to switch 
var desired_state:AmalgamationState;
## The attack state that amalgamation was in most recently 
var previous_attack_state:AmalgamationState;

func enter() -> void:
	desired_state = get_random_attack()
	await get_tree().create_timer(.2).timeout
	state_machine.change_state(self, desired_state.name)

func update(_delta:float) -> void:
	pass

func exit() -> void:
	previous_attack_state = desired_state
	desired_state = null

# FIXME this can return the same state twice in a row
func get_random_attack() -> AmalgamationState:
	var total_weight:float = attack_state_weights[0] + attack_state_weights[1] + attack_state_weights[2]
	var rand := RandomNumberGenerator.new().randf_range(0,total_weight)
	if rand <= attack_state_weights[0]:
		return attack_states[0]
	elif rand <= (attack_state_weights[0] + attack_state_weights[1]):
		return attack_states[1]
	else:
		return attack_states[2]
