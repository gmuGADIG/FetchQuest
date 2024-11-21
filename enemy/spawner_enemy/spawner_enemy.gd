class_name SpawnerEnemy extends Enemy

@export var spawned_enemy : PackedScene
@export var spawn_amount : int
@export var spawn_on_death : bool
@export var spawn_rate : float
@export var spawn_cap : int
@export var spawn_animation_length : float

@onready var SpawnerEnemyTimer : Timer = get_node("SpawnerEnemyTimer")
@onready var TimeToSpawnTimer : Timer = get_node("TimeToSpawnTimer")

## Used to find a safe location to spawn the child.
@onready var child_spawn_finder: RayCast2D = $ChildSpawnFinder

## Set this to the distance from the parent that the child should be spawned
## at to ensure proper behavior (no strange physics).
@export var safe_spawn_distance_from_self: float = 100.0

## Set this to the distance from a wall that the child should be spawned at
## to ensure proper physics behavior.
@export var safe_spawn_distance_from_wall: float = 100.0

var spawned_list : Array[Variant] ## To keep track of all the enemies it spawns

var is_spawning := false ## To keep track of when the enemy is spawning another enemy

func _ready() -> void:
	# wait a single frame in case our _ready was called before the player's
	await get_tree().process_frame
	
	# set all the properties and make all the connections provided the enemy does not spawn on death :3
	if not spawn_on_death:
		SpawnerEnemyTimer.wait_time = spawn_rate
		TimeToSpawnTimer.wait_time = spawn_animation_length
		
		SpawnerEnemyTimer.start()

		SpawnerEnemyTimer.connect("timeout", start_enemy_spawn)
		TimeToSpawnTimer.connect("timeout", spawn_mini_enemy)

# For now: To go with the graphiics: We simply sit in one place?
#func _physics_process(_delta: float) -> void:
	#if Player.instance == null: 
		#return
#
	## Move towards and look at the player 
	#var movement_direction := (Player.instance.global_position - global_position).normalized()
	#
	## to fix the movement speed issue
	#if not is_spawning:
		#velocity = movement_direction * 100 
	#else:
		#velocity = movement_direction * 0
	#look_at(Player.instance.global_position)
	#move_and_slide()

func _process_agressive(delta : float) -> void :
	pass

func start_enemy_spawn() -> void:
	if is_spawning: return
	else: is_spawning = true
	enemy_state = EnemyState.AGRESSIVE
	print("Starting enemy spawn!")
	
	TimeToSpawnTimer.start()
	# Play the animation, with length based on the exported property.
	$AnimationPlayer.play("spawner_enemy_detect_player", -1, 1.0 / spawn_animation_length)


## Function to handle enemy spawns
func spawn_mini_enemy() -> void:
	enemy_state = EnemyState.ROAMING
	is_spawning = false
	# Enemy needs to exist in order for this function to run,
	if spawned_enemy == null: return
	# and then clean up the spawned enemies array
	clear_dead_enemies()
	
	print("Spawner Enemy Spawned ", spawned_enemy.get_path())
	for _i in spawn_amount:
		# check to see if we haven't reached cap
		if spawned_list.size() >= spawn_cap: continue
		
		spawn_single_child()
		
func spawn_single_child() -> void:
	# if not, business as usual (welcome to the instantiation station!)
	var spawned := spawned_enemy.instantiate()
	spawned.position = position
	add_sibling(spawned)
	
	# Compute a convenient distance for the raycast
	var dist := (safe_spawn_distance_from_self + safe_spawn_distance_from_wall * 2.0)
	
	# Try to reposition the child to not overlap with us.
	for i in range(0, 100):
		child_spawn_finder.target_position = Vector2.from_angle(randf_range(0, TAU)) * dist
		child_spawn_finder.force_raycast_update()
		
		#var target_pos := global_position + child_spawn_finder.target_position
		if child_spawn_finder.is_colliding():
			# Note: get collision point is global.
			var col_point := child_spawn_finder.get_collision_point()
			var vector_to := col_point - global_position
			
			var correct_len := vector_to.length() - safe_spawn_distance_from_wall
			# If the correct len is negative, we can't use this point, try
			# a different one.
			if correct_len < 0:
				continue
			# If the correct len is too close to use, we can't spawn the enemy.
			if correct_len < safe_spawn_distance_from_self:
				continue
			var vector_far_from_wall := vector_to.normalized() * correct_len
			
			var target_pos := global_position + vector_far_from_wall
			if spawned is SpawnerEnemyBaby:
				spawned.spawn_target_position = target_pos
			else:
				spawned.global_position = target_pos
			break
		else:
			# The raycast is longer than the min distance, so we can just
			# move in that direction.
			var target_pos := global_position + child_spawn_finder.target_position.normalized() * safe_spawn_distance_from_self
			if spawned is SpawnerEnemyBaby:
				spawned.spawn_target_position = target_pos
			else:
				spawned.global_position = target_pos
			# We're done.
			break
			
	spawned_list.append(spawned)

## Helper function to remove dead enemies from spawned_list 
func clear_dead_enemies() -> void:
	var i := 0
	while i < spawned_list.size():
		if not is_instance_valid(spawned_list[i]):
			spawned_list.remove_at(i)
		else:
			i += 1

## Overriding of on_death (adding extra functionality)
func on_death() -> void:
	if spawn_on_death:
		spawn_mini_enemy()
	super.on_death()
