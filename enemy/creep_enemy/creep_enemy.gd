class_name CreepEnemy extends Enemy

## The scene that will be instantiated when the enemy is spawning it's creep
@export var creep_prefab:PackedScene
## The seconds between each creep spawn
@export var creep_spawn_time:float = 3

func _ready() -> void:
	# Set up the spawning timer
	$CreepSpawnTimer.wait_time = creep_spawn_time
	$CreepSpawnTimer.start()

# NOTE 	This movement code is taken from the test_enemy 
#   	and will probably not stay like this forever
func _physics_process(_delta: float) -> void:
	if Player.instance == null: 
		return

	# Move towards and look at the player 
	var movement_direction := (Player.instance.global_position - global_position).normalized()
	velocity = movement_direction * 300#movement_speed
	look_at(Player.instance.global_position)
	move_and_slide()
	


func _on_creep_spawn_timer_timeout() -> void:
	if creep_prefab == null:
		return
	# Spawn creep when the timer runs out
	print("creep_enemy.gd: Spawned creep") 
	var creep := creep_prefab.instantiate()
	creep.position = get_parent().to_local(self.global_position)
	add_sibling(creep)
