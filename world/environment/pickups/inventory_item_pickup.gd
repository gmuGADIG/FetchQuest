extends CharacterBody2D

## When the item is picked up, this string is added into the inventory.
## This can be anything, but you must ensure consistency when referring to it elsewhere (e.g. checking for it in the inventory)
@export var inventory_key: String

func _ready() -> void:
	assert(inventory_key != "", "Item '%s' has an empty inventory key!" % inventory_key)

func _on_pickup_area_body_entered(body: Node2D) -> void:
	if body is not Player: return
	
	PlayerInventory.add_quantity(inventory_key, 1)
	queue_free()
	print("inventory_item_pickup.gd: Picked up item '%s'" % inventory_key)
