extends Enemy
class_name SpawnerEnemyBaby

# The genious idea:
# - Animate the sprite instead of the thing.
# - Make the animation very fast.
# - Pog.

@export var attack_radius: float = 30

var spawn_target_position: Vector2 = Vector2.ZERO
## Timer used to animate the enemy spawning into its target position.
var spawn_timer: float = SPAWN_TIMER_MAX
@onready var spawn_pre_position: Vector2 = global_position

const SPAWN_TIMER_MAX := 0.2

func _ready() -> void:
	pass
	# Disable collision until we are spawned in.
	#$CollisionShape2D.disabled = true
	

func _process(delta: float) -> void:
	super._process(delta)
	
	if spawn_timer > 0:
		spawn_timer -= delta
		if spawn_timer < 0:
			spawn_timer = 0
			$CollisionShape2D.disabled = false
		var one_minus_t := spawn_timer / SPAWN_TIMER_MAX
		var t := 1.0 - one_minus_t
		global_position = lerp(spawn_pre_position, spawn_target_position, t)
		scale.x = t
		scale.y = t
	
	var distance_to_player := global_position.distance_to(Player.instance.global_position)
	if distance_to_player < agressive_target_distance_max:
		if enemy_state == EnemyState.ROAMING:
			enemy_state = EnemyState.AGRESSIVE
	else:
		if enemy_state == EnemyState.AGRESSIVE:
			enemy_state = EnemyState.ROAMING

func _process_agressive(delta: float) -> void:
	# Approach the player, then do the attack animation.
	approach(Player.instance.global_position)
	
	if global_position.distance_to(Player.instance.global_position) < attack_radius:
		# Note: This re-enables and disables the HittingArea CollisionShape.godo
		$AnimationPlayer.play("attack")
		
