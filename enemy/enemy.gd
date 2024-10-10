# NOTE: This script applies to all enemies.
# To create a new enemy, create an inherited scene from the base enemy, then 
# replace the existing script with a new script extending `Enemy`.

class_name Enemy extends CharacterBody2D

var _player: Player

@export var max_health: int = 3
@onready var health := max_health

@export var movement_speed: float = 4.0
@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")



var enemy_state := EnemyState.ROAMING

enum EnemyState {
	ROAMING,
	AGRESSIVE,
	STUNNED
}

func _ready() -> void:
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	_player = Player.instance
	assert(_player != null, "No player exists in the scene!")
	actor_setup.call_deferred()


func actor_setup() -> void:
	await get_tree().physics_frame
	approach(_player.global_position)

func _process(delta: float) -> void:
	match enemy_state:
		EnemyState.ROAMING:
			_process_roaming(delta)
		EnemyState.AGRESSIVE:
			_process_agressive(delta)
		EnemyState.STUNNED:
			_process_stunned(delta)
	
		
## Damages the enemy, killing it if its health drops below zero.
## This should be called by the player's attacks when they hit an enemy.
func hurt(damage_event: DamageEvent) -> void:
	if health <= 0: return # don't die twice

	health -= damage_event.damage
	#position += damage_event.knockback
	
	print("Enemy.gd: Health of '%s' was lowered to %s/%s" % [get_path(), health, max_health])

	if health <= 0:
		queue_free()
		
func _process_roaming(delta: float) -> void:
	pass
	
func _process_agressive(delta: float) -> void:
	pass
	
func _process_stunned(delta: float) -> void:
	pass
	
	
	
func approach(target: Vector2) -> void:
	set_movement_target(target)

func set_movement_target(movement_target: Vector2) -> void:
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta: float) -> void:
# Do not query when the map has never synchronized and is empty.
	
	#if NavigationServer2D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		#return
	#if navigation_agent.is_navigation_finished():
		#return
	#if _player == null: return
	
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * movement_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)



func _on_velocity_computed(safe_velocity: Vector2) -> void:
		velocity = safe_velocity
		move_and_slide()
