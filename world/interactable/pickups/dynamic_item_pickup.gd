class_name DynamicItemPickup extends Item

## The name of an InventoryItem in the PlayerInventory autoload's `items` list.
@export var inventory_key: String

## When collected, the value is incremented by this amount
@export var amount := 1

## By default, collected items respawn when the scene is loaded.
## If true, this is prevented, making this item only able to be picked up one time.
@export var single_use := false

## Array of node paths, each corresponding to the path of a single-use item that's been collected already
static var collected_single_use_items: Array[NodePath] = []

func _ready() -> void:
	if single_use and collected_single_use_items.has(get_path()):
		queue_free()
		return
	
	var node_display_name := get_parent().name+"/"+name
	assert(inventory_key != "", "Item '%s' has an empty inventory key!" % node_display_name)
	assert(not inventory_key in PlayerInventory, "Item '%s' has key '%s', which is a built-in property of PlayerInventory. You probably want to use the `property_item_pickup` script instead." % [node_display_name, inventory_key])

func consume(consumer: Node2D) -> void:
	if (consumer is Player):
		PlayerInventory.add_quantity(inventory_key, amount)
		print("key_item_pickup.gd: Picked up item '%s'" % inventory_key)
		if single_use: collected_single_use_items.append(get_path())
		queue_free()
