class_name AmalgamationPillarsState extends AmalgamationState

## The actual pillar that will be spawned
@onready var pillar_scene:PackedScene = preload("res://enemy/amalgamation/amalgamation_pillar_of_light.tscn")
## How many pillars to spawn
@onready var pillar_count:int = amalgamation.pillar_count
## The time the pillar takes to fall
@onready var pillar_fall_time:float = amalgamation.pillar_fall_time
## The center of the room (for pillar spawning)
@onready var room_center:Node2D = amalgamation.room_center
## The center of the room (for pillar spawning)
@onready var room_size:Vector2 = amalgamation.room_size

## The current pillars that exist
var pillars_spawned: Array[Node2D] = []

func enter() -> void:
	print("amalgamation_pillars_state.gd: final destination reference")
	# Summon the pillars
	summon_pillars()
	# Idle after 8 seconds
	await get_tree().create_timer(pillar_fall_time * 1.25).timeout
	if amalgamation.state_machine.current_state != self:
		return
	amalgamation.state_machine.change_state(self, "Idle")

func update(_delta:float) -> void:
	pass

func exit() -> void:
	# Remove the pillars upon exiting
	for pillar in pillars_spawned:
		if is_instance_valid(pillar):
			pillar.queue_free()
	pillars_spawned = []

func spawn_pillar(location:Vector2) -> Node2D:
	# Summon a pillar at the requested location
	var pillar:Node2D = pillar_scene.instantiate()
	pillar.global_position = location
	pillar.fall_time = pillar_fall_time
	amalgamation.state_machine.get_parent().add_sibling(pillar)
	
	# Return the pillar for tracking purposes
	return pillar

func summon_pillars() -> void:
	# Spawn pillars randomly on screen
	for i in range(pillar_count - 1):
		var random_position:Vector2 = room_center.global_position + Vector2(randf_range(-room_size.x / 2, room_size.x / 2), randf_range(-room_size.y / 2, room_size.y / 2));
		pillars_spawned.append(spawn_pillar(random_position))
	
	# Spawn one pillar on the player
	pillars_spawned.append(spawn_pillar(Player.instance.global_position))
