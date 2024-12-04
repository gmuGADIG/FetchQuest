extends Enemy
class_name SpawnerEnemyBaby

@export var attack_radius: float = 30

## We animate the Sprite moving from the spawn_start_position to our own
## global position. That way, we have the sprite appear to spawn in, but
## there is no physics jank as we always exist with a real physics collider.
## To make sure this works alright, we should use a very quick animation so
## that it doesn't look too janky.
var spawn_start_position: Vector2 = Vector2.ZERO

## Timer used to animate the enemy spawning into its target position.
var spawn_timer: float = SPAWN_TIMER_MAX

## ASSUMPTION: The scaling is uniform.
@onready var sprite_scale: float = $Sprite2D.scale.x

@onready var sprite: Sprite2D = $Sprite2D

const SPAWN_TIMER_MAX := 0.15

func _ready() -> void:
	sprite.global_position = spawn_start_position
	# Hide sprite to avoid jank when it first appears.
	# If you can come up with a better solution, feel free...
	sprite.hide()

func _process(delta: float) -> void:
	super._process(delta)
	
	if spawn_timer > 0:
		spawn_timer -= delta
		# Show after one or two 60th of a second.
		if spawn_timer < SPAWN_TIMER_MAX - 0.0167:
			sprite.show()
		if spawn_timer < 0:
			spawn_timer = 0
		var one_minus_t := spawn_timer / SPAWN_TIMER_MAX
		var t := 1.0 - one_minus_t
		t = clamp(t, 0.0, 1.0)
		sprite.global_position = lerp(spawn_start_position, global_position, t)
		var s := sqrt(t) # Scale up faster
		sprite.scale.x = s * sprite_scale
		sprite.scale.y = s * sprite_scale
		
		
	
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
		# Make sure we can't attack until the spawn anim is done.
		if spawn_timer <= 0:
			# Note: This re-enables and disables the HittingArea CollisionShape.godo
			$AnimationPlayer.play("attack")
		
