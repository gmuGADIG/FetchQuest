# NOTE: This script applies to all enemies.
# To create a new enemy, create an inherited scene from the base enemy, then 
# replace the existing script with a new script extending `Enemy`.

class_name Enemy extends CharacterBody2D

@export var max_health: int = 3
@export var damage : int = 1
@export var knockback_force : int = 10
@onready var health := max_health

## Damages the enemy, killing it if its health drops below zero.
## This should be called by the player's attacks when they hit an enemy.
func hurt(damage_event: DamageEvent) -> void:
	if health <= 0: return # don't die twice

	health -= damage_event.damage
	#position += damage_event.knockback
	
	print("Enemy.gd: Health of '%s' was lowered to %s/%s" % [get_path(), health, max_health])

	if health <= 0:
		queue_free()

func _on_hitbox_body_entered(body: Node2D) -> void:
	var knockbackVector : Vector2 = Vector2.ZERO
	var player := body as Player
	if player != null:
		player.health -= damage
		print("player has taken damage, health: %s/%s" % [player.health,player.max_health])
		knockbackVector = (player.global_position - global_position) * knockback_force
		player.add_force(knockbackVector)
		
