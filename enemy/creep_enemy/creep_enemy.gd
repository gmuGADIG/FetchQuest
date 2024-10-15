class_name CreepEnemy extends Enemy

@export var creep_prefab:PackedScene
@export var creep_spawn_rate:float = .5

func _ready() -> void:
	$CreepSpawnTimer.wait_time = creep_spawn_rate
	$CreepSpawnTimer.start()

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
	print("creep_enemy.gd: Spawned creep") 
	var creep := creep_prefab.instantiate()
	creep.position = get_parent().to_local(self.global_position)
	add_sibling(creep)
