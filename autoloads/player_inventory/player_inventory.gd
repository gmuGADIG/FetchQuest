extends Node

## Autoload storing the player's stats and inventory
## 
## This script has dedicated fields for storing things, such as the player's Good Boy 
## Points balance, the number of bombs the player has, and the player's max health and 
## stamina. 
## [br][br]
## However, this autoload can also store arbitrary items, retrieved with a 
## string key. These arbitrary items are of type [InventoryItem] and are registered into
## the system by adding them to this autoloaded scene's [member items] list in the 
## inspector. For example:
##
## [codeblock]
## if PlayerInventory.good_boy_points >= 25:
##     PlayerInventory.good_boy_points -= 25
##     PlayerInventory.add_quantity("special_quest_item", 1)
## [/codeblock]
## [codeblock]
## if PlayerInventory.take_quantity("special_quest_item", 1):
##     print("congratulations! you are a good boy!")
## [/codeblock]

## Emitted when the amount of Good Boy Points the player has changes.
signal good_boy_points_updated

## Emitted when the amount of bombs the player has changes.
signal bombs_updated

## Emited when the max bombs of the player changes.
signal max_bombs_updated

## Emitted when the max health of the player changes
signal max_health_updated

## Emitted when the max stamina of the player changes
signal max_stamina_updated

## Emitted when the quantity of the item referred to by [param key] changes
signal item_updated(key: String)

## Number of Good Boy Points the player currently has
@export var good_boy_points: int = 0:
	set(v):
		good_boy_points = v
		good_boy_points_updated.emit()

## Number of bombs the player currently has
@export var bombs: int = 0:
	set(v):
		bombs = v
		bombs_updated.emit()

## The maximum
@export var max_bombs: int = 0:
	set(v):
		max_bombs = v
		max_bombs_updated.emit()

## The maximum health the player can have 
@export var max_health: int = 6:
	set(v):
		max_health = v
		max_health_updated.emit()

## The maximum number of stamina pips the player can have 
@export var max_stamina: int = 3:
	set(v):
		max_stamina = v
		max_stamina_updated.emit()

@export var speed_multiplier: float = 1
@export var sword_damage_multiplier: float = 1
		
##The amount of keys to unlock a door that the player has at any time
@export var door_keys: int = 0

@export var boss_door_keys: int = 0

## The various items the player can have
@export var items: Array[InventoryItem]

var _key_to_item: Dictionary = {}

func _ready() -> void:
	for item in items:
		_key_to_item[item.key] = item

## Returns the number of an item the player is holding.
func get_quantity(key: String) -> int:
	return _key_to_item[key].quantity_held

## Gives the player [param amount] of the item referred to by [param key]
func add_quantity(key: String, amount: int) -> void:
	_key_to_item[key].quantity_held += amount
	item_updated.emit(key)

## Takes [param amount] of an item referred to by [param key] from the player. 
## [br][br]
## Will not take more than the player has, returning [code]false[/code] if the player 
## does not have enough of the item, [code]true[/code] otherwise.
func remove_quantity(key: String, amount: int) -> bool:
	if amount > _key_to_item[key].quantity_held: return false
	item_updated.emit(key)
	_key_to_item[key].quantity_held -= amount
	return true

## Attemps to remove a key from the players inventory
## If the player has a key, removes one and returns true.
## Otherwise, does nothing.
## Can be either normal keys ([code]door_keys[/code]), or boss keys ([code]boss_door_keys[/code])
func use_door_key(is_boss_door: bool) -> bool:
	if is_boss_door and boss_door_keys > 0:
		boss_door_keys -= 1
		return true
	elif not is_boss_door and door_keys > 0:
		door_keys -= 1
		return true
	else:
		return false

func serialize() -> Dictionary:
	var _items := {}
	for key: String in _key_to_item.keys():
		_items[key] = get_quantity(key) 

	return {
		good_boy_points = good_boy_points,
		bombs = bombs,
		max_bombs = max_bombs,
		max_health = max_health,
		max_stamina = max_stamina,
		door_keys = door_keys,
		boss_door_keys = boss_door_keys,
		items = _items,
		speed_multiplier = speed_multiplier,
		sword_damage_multiplier = sword_damage_multiplier
	}

func deserialize(data: Dictionary) -> void:
	good_boy_points = data.good_boy_points
	bombs = data.bombs
	max_bombs = data.max_bombs
	max_health = data.max_health
	max_stamina = data.max_stamina
	door_keys = data.door_keys
	boss_door_keys = data.boss_door_keys
	speed_multiplier = data.speed_multiplier
	sword_damage_multiplier = data.sword_damage_multiplier

	for key: String in data.items:
		_key_to_item[key].quantity_held = data.items[key]
