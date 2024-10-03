# NOTE: This script applies to all enemies.
# To create a new enemy, create an inherited scene from the base enemy, then 
# replace the existing script with a new script extending `Enemy`.

class_name Enemy extends CharacterBody2D

@export var max_health: int = 3
@onready var health := max_health
@export var roaming_radius : float = 100
var enemy_state := EnemyState.ROAMING

var target_position : Vector2 = Vector2.ZERO
var roaming_time : float = 0.5

enum EnemyState {
	ROAMING,
	AGRESSIVE,
	STUNNED
}

func _ready() -> void:
	_get_target_position(5) #replace with default enemy move distance 

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
func hurt(event: DamageEvent) -> void:
	if health <= 0: return # don't die twice

	health -= event.damage
	position = position + DamageEvent.calculate_knockback_vector(event,self.position)
	
	print("Enemy.gd: Health of '%s' was lowered to %s/%s" % [get_path(), health, max_health])

	if health <= 0:
		queue_free()
		
# check to
func _process_roaming(delta: float) -> void:
	if _position_close_to_target(target_position, 0.3):
		_get_target_position(roaming_radius)
	if roaming_time <= 0:
		approach(target_position)
	else:
		roaming_time = roaming_time - delta
	pass

# checks to see if the enemy is close to a postion within threshold
func _position_close_to_target(target: Vector2, threshold: float) -> bool:
	return target.distance_to(position) <= threshold
	pass
	
# sets the target_position to a position on the edge of a circle witht he enemy at the middle.
# also sets the timer to 0.2 to 1 seconds
func _get_target_position(radius: float) -> void:
	var radian: float = randf_range(0,(2*3.14))
	var target_position := position + Vector2(radius * cos(radian), radius * sin(radian))
	roaming_time = randf_range(0.2,1)
	pass
	
	# add public target position, check if target pos it close enough to current pos, wait for X seconds, then get new target postion
	##Movement function(position)
	pass

func approach(target: Vector2) -> void: #DONT USE THIS
	pass
	
func _process_agressive(delta: float) -> void:
	pass
	
func _process_stunned(delta: float) -> void:
	pass
	
