# NOTE: This script applies to all enemies.
# To create a new enemy, create an inherited scene from the base enemy, then 
# replace the existing script with a new script extending `Enemy`.

class_name Enemy extends CharacterBody2D

@export var max_health: int = 3
@onready var health := max_health


@export var too_close: float = 1
@export var too_far: float = 100

var enemy_state := EnemyState.ROAMING

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
	
	
func approach(target: Vector2) -> void:#THIS IS DUMMY CODE, USE THE METHOD FROM THE NAVIGATION BRANCH
	
	pass
	
