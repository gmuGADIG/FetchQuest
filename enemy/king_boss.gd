class_name KingBoss extends Enemy


# NOTE 	This movement code is taken from the test_enemy 
#   	and will probably not stay like this forever
func _ready() -> void:
	# Wait a single frame in case our _ready was called before the player's
	await get_tree().process_frame

func _physics_process(_delta: float) -> void:
	if Player.instance == null: 
		return

	# Move towards and look at the player 
	var movement_direction := (Player.instance.global_position - global_position).normalized()
	velocity = movement_direction * 300#movement speed
	look_at(Player.instance.global_position)
	move_and_slide()

'''
func _pick_attack() -> void:
	int attack = randi() % 3 + 1
	
	match attack:
		1:
			asdfasdfasdfas
		2:
			asdfasdfasdfasdf
		3:
			asdfasdfasdfasdf
		
	# if it's the same as the last one, roll again
	# once we have a number, run its respective attack function'
'''
