class_name SpawnerEnemy extends Enemy

@export var spawned_enemy : PackedScene
@export var spawn_amount : int
@export var spawn_on_death : bool
@export var spawn_rate : float
@export var spawn_cap : int
@export var spawn_animation_length : float

@onready var SpawnerEnemyTimer : Timer = get_node("SpawnerEnemyTimer")

var spawned_list : Array[PackedScene] ## To keep track of all the enemies it spawns

func _ready() -> void:
	# wait a single frame in case our _ready was called before the player's
	await get_tree().process_frame
	if not spawn_on_death:
		SpawnerEnemyTimer.wait_time = spawn_rate
		SpawnerEnemyTimer.start()

func _physics_process(_delta: float) -> void:
	if Player.instance == null: return
	
	else:
		pass
		velocity = (Player.instance.global_position - global_position).normalized() * 150
	move_and_slide()

	look_at(Player.instance.global_position)
	SpawnerEnemyTimer.connect("timeout", spawn_mini_enemy)

func spawn_mini_enemy() -> void:
	if spawned_enemy == null: return
	else:
		print("Spawner Enemy Spawned ", spawned_enemy.get_path())
		var spawned := spawned_enemy.instantiate()
		spawned.position = position
		add_sibling(spawned)
		
func on_death() -> void:
	if spawn_on_death:
		for _i in spawn_amount:
			spawn_mini_enemy()
	super.on_death()
