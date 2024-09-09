@tool
class_name InventoryItem extends Resource

## The name of this item: to be displayed on screen
@export var display_name: String:
	set(v): # update the name displayed in the inspector to display_name
		display_name = v
		resource_name = v

## The name of this item to be used in code
@export var key: String

## The amount of this item currently in the player's inventory
@export var quantity_held: int = 0
