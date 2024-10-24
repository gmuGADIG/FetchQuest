class_name SpawnerEnemy extends Enemy

@export var spawned_enemy : PackedScene
@export var spawn_amount : int
@export var spawn_on_death : bool
@export var spawn_rate : float
@export var spawn_cap : int
@export var spawn_animation_length : float

@onready var SpawnerEnemyTimer : Timer = get_node("SpawnerEnemyTimer")
@onready var TimeToSpawnTimer : Timer = get_node("TimeToSpawnTimer")

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

func _physics_process(_delta: float) -> void:
	if Player.instance == null: return
	else: if is_spawning: return
	move_and_slide()

	look_at(Player.instance.global_position)

func _process_agressive(delta : float) -> void :
	pass

func start_enemy_spawn() -> void:
	if is_spawning: return
	else: is_spawning = true
	enemy_state = EnemyState.AGRESSIVE
	print("Starting enemy spawn!")
	
	TimeToSpawnTimer.start()


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
		
		# if not, business as usual (welcome to the instantiation station!)
		var spawned := spawned_enemy.instantiate()
		spawned.position = position
		add_sibling(spawned)
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
