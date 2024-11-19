class_name AmalgamationSpittingState extends AmalgamationState

## The enemies that can be spat out by the amalgamation
@onready var possible_enemies:Array[PackedScene] = amalgamation.spitting_possible_enemies
## The amount of times that the amalgamation will spit before ending the attack
@onready var spitting_number:int = amalgamation.spitting_number
## The distance from the mouth that enemies and the player will be spat out
@onready var spitting_distance:float = amalgamation.spitting_distance
## The duration of this state
@onready var duration:float = amalgamation.spitting_state_duration;
## The time in seconds between each enemy being spat out
@onready var spitting_delay:float = duration / spitting_number;

func enter() -> void:
	# Play animation
	amalgamation.animation_player.play("Spitting")
	
	# Spit however much we want (with a delay)
	for i in range(spitting_number):
		spit()
		await get_tree().create_timer(spitting_delay).timeout

	# Idle after spitting all enemies
	if amalgamation.state_machine.current_state != self:
		return
	amalgamation.state_machine.change_state(self, "Idle")
	
func update(_delta:float) -> void:
	pass

func exit() -> void:
	pass

func spit() -> void:
	print("amalgamation_spitting_state.gd: insert pokemon reference")
	
	# Spawn a random enemy in the mouth
	var enemy:Enemy = possible_enemies.pick_random().instantiate()	
	enemy.global_position = %MouthArea.global_position
	amalgamation.state_machine.get_parent().add_sibling(enemy)
	
	# Spit it out towards the player
	var tween := create_tween()
	var direction_to_player := enemy.global_position.direction_to(Player.instance.global_position)
	tween.tween_property(enemy, "global_position", enemy.global_position + direction_to_player * spitting_distance, 1.5)
