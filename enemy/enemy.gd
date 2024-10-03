# NOTE: This script applies to all enemies.
# To create a new enemy, create an inherited scene from the base enemy, then 
# replace the existing script with a new script extending `Enemy`.

class_name Enemy extends CharacterBody2D

@export var max_health: int = 3
@onready var health := max_health

@export var enemy_drop_chance_percent: int = 50 # 50 = 50% chance

var _player : Player

func _ready() -> void:
	await get_tree().process_frame
	_player = Player.instance

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
	
	var eligible : Array[GenericItemPickup.item_type]
	# otherwise, let's check eligibility to drop items
	# if the player does not have max hearts, then lets do hearts
	if (_player.health < _player.max_health):
		# do hearts
		eligible.append(GenericItemPickup.item_type.HEALTH)
	# if the player does not have max bombs and have unlocked them yet, then lets do bombs
	if (_player.bombs != _player.max_bombs and _player.unlocked_bombs):
		# do bombs
		eligible.append(GenericItemPickup.item_type.BOMB)
	# in that case, stamina will always be available
	eligible.append(GenericItemPickup.item_type.STAMINA)
	
	# If, somehow, there are no eligible items, then sound the alarms and bail 
	if (eligible.is_empty()):
		print("SOMETHING WENT HORRIBLY WRONG.")
		return
	
	var chosen : int = eligible.pick_random()
	
	match chosen:
		GenericItemPickup.item_type.HEALTH:
			var instantiated : Variant = load("uid://c3b7wkf6shwp1").instantiate()
			instantiated.transform = transform
			instantiated.rotation = 0
			add_sibling(instantiated)
		GenericItemPickup.item_type.BOMB:
			var instantiated : Variant = load("uid://cxgodqe6st3jf").instantiate()
			instantiated.transform = transform
			instantiated.rotation = 0
			add_sibling(instantiated)
		GenericItemPickup.item_type.STAMINA:
			
			# ALERT ALERT ALERT: add stamina pickup :D
			
			#var instantiated : Variant = load("ADD STAMINA RAAH").instantiate()
			#instantiated.transform = transform
			#instantiated.rotation = 0
			#add_sibling(instantiated)
			
			pass
	
	print("Item ID ", chosen, " was dropped by ", get_path())
	
