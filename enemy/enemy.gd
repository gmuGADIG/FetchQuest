# NOTE: This script applies to all enemies.
# To create a new enemy, create an inherited scene from the base enemy, then 
# replace the existing script with a new script extending `Enemy`.

class_name Enemy extends CharacterBody2D

@export var max_health: int = 3
@onready var health := max_health

@export var enemy_drop_chance_percent: int = 50 # 50 = 50% chance

var player : Player = Player.instance

## Damages the enemy, killing it if its health drops below zero.
## This should be called by the player's attacks when they hit an enemy.
func hurt(damage_event: DamageEvent) -> void:
	if health <= 0: return # don't die twice

	health -= damage_event.damage
	#position += damage_event.knockback
	
	print("Enemy.gd: Health of '%s' was lowered to %s/%s" % [get_path(), health, max_health])

	if health <= 0:
		on_enemy_death()
		queue_free()

## Function to call upon death of enemy
func on_enemy_death() -> void:
	# if the chance fails, bail out of the function and do nothing
	if (randi_range(1,100) > enemy_drop_chance_percent): return
	
	# otherwise, let's check eligibility to drop items
	# if the player has max hearts, then dont do hearts
	if (player.health == player.max_health):
		# dont do hearts
		pass
	# if the player has max bombs or havent unlocked them yet, then dont do bombs
	if (player.bombs == player.max_bombs or !player.unlocked_bombs):
		# dont do bombs
		pass
	# in that case, stamina will always be available
