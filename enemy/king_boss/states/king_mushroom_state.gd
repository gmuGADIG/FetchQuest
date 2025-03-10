class_name KingMushroomState extends KingState

## The mushrooms that currently exist in the scene
var mushrooms_spawned:Array[Node2D] = []

func enter() -> void:
	king.animated_sprite.play("mushroom_attack")

	# Summon the mushrooms, wait until they have exploded, switch to idle
	summon_shrooms()

	var flag := true
	while flag:
		await get_tree().process_frame

		flag = false
		for mushroom in mushrooms_spawned:
			if is_instance_valid(mushroom):
				flag = true
				break
	
	state_machine.change_state(self, "Idle")

func exit() -> void:
	# Remove all mushrooms and reset the array
	for shroom in mushrooms_spawned:
		if is_instance_valid(shroom):
			shroom.queue_free()
	mushrooms_spawned = []

func spawn_mushroom(location:Vector2) -> Node2D:
	# Summon a mushroom at the requested location
	var mushroom:Node2D = king.mushroom_scene.instantiate()
	mushroom.global_position = location
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
