class_name AmalgamationPillarsState extends AmalgamationState

## The actual pillar that will be spawned
@export var pillar_scene:PackedScene
## How many pillars to spawn
@export var pillar_count:int = 15
## The
@export var pillar_lifetime:float = 5

## The current pillars that exist
var pillars_spawned: Array[Node2D] = []

func enter() -> void:
	# Summon the pillars
	summon_pillars()
	# Idle after 8 seconds
	await get_tree().create_timer(pillar_lifetime * 1.25).timeout
	if state_machine.current_state != self:
		return
	state_machine.change_state(self, "Idle")

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
	pillar.lifetime = pillar_lifetime
	state_machine.get_parent().add_sibling(pillar)
	# Return the pillar for tracking purposes
	return pillar

func summon_pillars() -> void:
	# Spawn pillars randomly on screen
	var screen_width:float = get_viewport().size.x
	var screen_height:float = get_viewport().size.y
	for i in range(pillar_count - 1):
		var random_position:Vector2 = Player.instance.global_position + Vector2(randf_range(-screen_width / 2, screen_width / 2),randf_range(-screen_height / 2,screen_height / 2));
		pillars_spawned.append(spawn_pillar(random_position))
	
	# Spawn one pillar on the player
	pillars_spawned.append(spawn_pillar(Player.instance.global_position))
