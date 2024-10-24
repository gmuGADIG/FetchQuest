class_name AmalgamationSpittingState extends AmalgamationState

@export var possible_enemies:Array[PackedScene]
@export var spitting_number:int = 3
func enter() -> void:
	# Spit however much we want (with a delay)
	for i in range(spitting_number):
		spit()
		await get_tree().create_timer(2).timeout
	
	# Idle after spitting all enemies
	if state_machine.current_state != self:
		return
	state_machine.change_state(self, "Idle")
	
func update(_delta:float) -> void:
	pass

func exit() -> void:
	pass

func spit() -> void:
	# Spawn a random enemy in the mouth
	var enemy:Enemy = possible_enemies.pick_random().instantiate()	
	enemy.global_position = %MouthArea.global_position
	state_machine.get_parent().add_sibling(enemy)
	
	# Spit it out towards the player
	var tween := create_tween()
	var direction_to_player := enemy.global_position.direction_to(Player.instance.global_position)
	tween.tween_property(enemy, "global_position", enemy.global_position + direction_to_player * 400, 1.5)
	#NOTE idk why enemies dont move after being spat out but i think its not related to this
