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
		
##The amount of keys to unlock a door that the player has at any time
@export var door_keys: int = 0

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
	item_updated.emit(key)
	_key_to_item[key].quantity_held += amount

## Takes [param amount] of an item referred to by [param key] from the player. 
## [br][br]
## Will not take more than the player has, returning [code]false[/code] if the player 
## does not have enough of the item, [code]true[/code] otherwise.
func remove_quantity(key: String, amount: int) -> bool:
	if amount > _key_to_item[key].quantity_held: return false
	item_updated.emit(key)
	_key_to_item[key].quantity_held -= amount
	return true
	
## Adds 1 to [code]door_keys[/code]
func add_door_key() -> void:
	door_keys += 1
	

## Attemps to remove a key from the players inventory.[br][br]
## If the player has more than 0 [code]door_keys[/code],
## returns [code]true[/code] and decreases [code]door_keys[/code] by 1. [br][br]
## Otherwise, [code]false[/code] will be returned, and [code]door_keys[/code]
## will not be changed.
func use_door_key() -> bool:
	if (door_keys > 0):
		door_keys -= 1
		return true
	else:
		return false
