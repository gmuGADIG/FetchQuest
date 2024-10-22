class_name AmalgamationIdleState extends AmalgamationState

@export_group("Attack States")
## The node that contains the sucking logic
@export var sucking_state:AmalgamationSuckingState
## The node that contains the pillars logic
@export var pillar_state:AmalgamationPillarsState
## The node that contains the spitting logic
@export var spit_state:AmalgamationSpittingState

## The states that are considered attacking states 
@onready var attack_states:Array[AmalgamationState] = [sucking_state, pillar_state, spit_state]

@export_group("Attack Weights")
## The weight of the sucking state being selected
@export var sucking_weight:float = 1
## The weight of the pillar state being selected
@export var pillar_weight:float = 1
## The weight of the spitting state being selected
@export var spit_weight:float = 1

## The weights of each attack state being chosen (in order of the attack_states array)
@onready var attack_state_weights:Array[float] = [sucking_weight, pillar_weight, spit_weight];

## The next state amalgamation will be in once ready to switch 
var desired_state:AmalgamationState;
## The attack state that amalgamation was in most recently 
var previous_attack_state:AmalgamationState;

func enter() -> void:
	# Switch to a random attack state after a timer ends
	desired_state = get_random_attack()
	await get_tree().create_timer(1).timeout
	if state_machine.current_state != self:
		return
	state_machine.change_state(self, desired_state.name)

func update(_delta:float) -> void:
	pass

func exit() -> void:
	# Update variables
	previous_attack_state = desired_state
	desired_state = null

# Returns an attack state to switch to based off weights
# It also prevents repeating the same one twice in a row
func get_random_attack() -> AmalgamationState:
	# Set up the lists to select from
	var possible_states:Array[AmalgamationState] = []
	var possible_weights:Array[float] = []
	var total_weight:float 

	# Populate the lists to avoid selecting the same attack twice
	for i in range(attack_states.size()):
		if attack_states[i] != previous_attack_state:
			possible_states.append(attack_states[i])
			possible_weights.append(attack_state_weights[i])
			total_weight += attack_state_weights[i]

	# Generate a random number
	var rand := RandomNumberGenerator.new().randf_range(0,total_weight)

	# Select an attack based off the random number and the weights
	var cum_weight:float = 0.0
	for i in range(possible_states.size()):
		cum_weight += possible_weights[i]
		if rand <= cum_weight:
			return possible_states[i]
	
	# Fallback just in case the random function has unforseen edgecases
	printerr("amalgamation_idle_state.gd: Issue with selecting the the amalgamation attack state")
	return null
