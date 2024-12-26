class_name KingIdleState extends KingState

var desired_state:KingState = null

func enter() -> void:
	await get_tree().create_timer(king.idle_state_duration).timeout
	if state_machine.current_state != self:
		return
	desired_state = get_random_attack()
	state_machine.change_state(self, desired_state.name)

func update(_delta:float) -> void:
	pass

func exit() -> void:
	king.previous_attack_state = desired_state
	desired_state = null

# Returns an attack state to switch to based off weights
# It also prevents repeating the same one twice in a row
func get_random_attack() -> KingState:
	# Set up the lists to select from
	var possible_states:Array[KingState] = []
	var possible_weights:Array[float] = []
	var total_weight:float = 0;

	# Populate the lists to avoid selecting the same attack twice
	for i in range(king.attack_states.size()):
		if king.attack_states[i] != king.previous_attack_state:
			possible_states.append(king.attack_states[i])
			possible_weights.append(king.attack_state_weights[i])
			total_weight += king.attack_state_weights[i]

	# Generate a random number
	var rand := RandomNumberGenerator.new().randf_range(0, total_weight)

	# Select an attack based off the random number and the weights
	var cum_weight:float = 0.0
	for i in range(possible_states.size()):
		cum_weight += possible_weights[i]
		if rand <= cum_weight:
			return possible_states[i]
	
	# Fallback just in case the random function has unforseen edgecases
	printerr("king_idle_state.gd: Issue with selecting the king attack state")
	return null
