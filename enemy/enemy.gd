# NOTE: This script applies to all enemies.
# To create a new enemy, create an inherited scene from the base enemy, then 
# replace the existing script with a new script extending `Enemy`.

class_name Enemy extends CharacterBody2D

@export var max_health: int = 3
@onready var health := max_health

@export_range(0, 1) var pickup_drop_chance: float = 0.5 ## Chance of dropping a pick-up (hp, bomb, or stamina) on death

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
		on_death()
		queue_free()

## Function to call upon death of enemy
func on_death() -> void:
	# if the chance fails, bail out of the function and do nothing
	if (randf() > pickup_drop_chance): return
	
	# add bombs, health, and stamina to the list of possible drops, after checking if they're eligible
	var eligible : Array[GenericItemPickup.item_type]
	if (Player.instance.health < Player.instance.max_health):
		eligible.append(GenericItemPickup.item_type.HEALTH)
	if (PlayerInventory.bombs < PlayerInventory.max_bombs): # TODO: only drop bombs after they're unlocked
		eligible.append(GenericItemPickup.item_type.BOMB)
	eligible.append(GenericItemPickup.item_type.STAMINA) # stamina is unconditional
	
	# If, somehow, there are no eligible items, then sound the alarms and bail 
	if (eligible.is_empty()):
		push_error("enemy.gd: No valid pickup drops were possible!")
		return
	
	# pick an eligible item and get the scene path
	var chosen: GenericItemPickup.item_type = eligible.pick_random()
	var scene_path: String
	match chosen:
		GenericItemPickup.item_type.HEALTH:
			scene_path = "uid://ba67nujgxs2xm"
		GenericItemPickup.item_type.BOMB:
			scene_path = "uid://bcxhlev2837g6"
		GenericItemPickup.item_type.STAMINA:
			scene_path = "uid://nqdbsvt7vcge"
		_:
			assert(false, "unhandled pickup drop!")
	
	# instantiate the chosen pickup
	var dropped_item: Node2D = load(scene_path).instantiate()
	dropped_item.position = position
	add_sibling(dropped_item)
	print("Item '", dropped_item.name, "' was dropped by ", get_path())
	
