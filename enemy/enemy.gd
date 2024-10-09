# NOTE: This script applies to all enemies.
# To create a new enemy, create an inherited scene from the base enemy, then 
# replace the existing script with a new script extending `Enemy`.

class_name Enemy extends CharacterBody2D

@export var max_health: int = 3
@onready var health := max_health
# the max distance the entity will move from its starting position, aka that radius of the circle that the entity is allowed to move in
@export var roaming_radius : float = 100
var enemy_state := EnemyState.ROAMING

@onready var original_position : Vector2 = position
@onready var target_position: Vector2 = _get_roaming_target()
var roaming_time : float = 0.0

enum EnemyState {
	ROAMING,
	AGRESSIVE,
	STUNNED
}

func _process(delta: float) -> void:
	match enemy_state:
		EnemyState.ROAMING:
			_process_roaming(delta)
		EnemyState.AGRESSIVE:
			_process_agressive(delta)
		EnemyState.STUNNED:
			_process_stunned(delta)
	move_and_slide()
	
		
## Damages the enemy, killing it if its health drops below zero.
## This should be called by the player's attacks when they hit an enemy.
func hurt(event: DamageEvent) -> void:
	if health <= 0: return # don't die twice

	health -= event.damage
	position = position + DamageEvent.calculate_knockback_vector(event,self.position)
	
	print("Enemy.gd: Health of '%s' was lowered to %s/%s" % [get_path(), health, max_health])

	if health <= 0:
		queue_free()
		
# checks to see if the entity is close enough to its target position
# if so reset romaing time and wait until its 0 or negitative and then move towards the new target position
func _process_roaming(delta: float) -> void:
	var target_reached := position.distance_to(target_position) <= 5.0
	if target_reached: # target reached; set new target and wait
		target_position = _get_roaming_target()
		roaming_time = randf_range(.5, 1)
		velocity = Vector2.ZERO
	elif roaming_time > 0: # waiting; subtract from timer and do nothing
		roaming_time -= delta
	else: # still approaching target
		approach(target_position)

## gets a new random position to roam towards
func _get_roaming_target() -> Vector2:
	var radian: float = randf_range(0, 2*PI)
	var distance: float =  randf_range(0, roaming_radius)
	return original_position + Vector2(distance * cos(radian), distance * sin(radian))

func approach(target: Vector2) -> void:
	velocity = position.direction_to(target) * 200 # temporary movement code. TODO: replace with proper navigation
	
func _process_agressive(delta: float) -> void:
	pass
	
func _process_stunned(delta: float) -> void:
	pass
	
