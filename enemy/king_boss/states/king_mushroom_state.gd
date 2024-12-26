class_name KingMushroomState extends KingState

@onready var mushroom_explode_time:float = king.mushroom_state_duration * .75

var mushrooms_spawned:Array[Node2D] = []
func enter() -> void:
	summon_shrooms()
	await get_tree().create_timer(king.mushroom_state_duration).timeout
	if state_machine.current_state == self:
		state_machine.change_state(self, "Idle")

func update(_delta:float) -> void:
	pass

func exit() -> void:
	for shroom in mushrooms_spawned:
		if is_instance_valid(shroom):
			shroom.queue_free()
	mushrooms_spawned = []

func spawn_mushroom(location:Vector2) -> Node2D:
	# Summon a mushroom at the requested location
	var mushroom:Node2D = king.mushroom_scene.instantiate()
	mushroom.global_position = location
	mushroom.time_until_explosion = mushroom_explode_time
	king.add_sibling(mushroom)
	
	# Return the mushroom for tracking purposes
	return mushroom

func summon_shrooms() -> void:
	# Spawn mushrooms randomly on screen
	for i in range(king.mushroom_count - 1):
		var random_position:Vector2 = king.room_center.global_position + Vector2(randf_range(-king.room_size.x / 2, king.room_size.x / 2), randf_range(-king.room_size.y / 2, king.room_size.y / 2));
		mushrooms_spawned.append(spawn_mushroom(random_position))
	
	# Spawn one mushroom on the player
	mushrooms_spawned.append(spawn_mushroom(Player.instance.global_position))
