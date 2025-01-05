class_name PropertyItemPickup extends Item

## The property of the PlayerInventory class to increment, e.g. "bombs", "good_boy_points", "door_keys"
@export var item_property: StringName

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
	assert(item_property != "", "Item '%s' has an empty inventory key!" % node_display_name)
	assert(item_property in PlayerInventory, "Item '%s' has key '%s', which does not exist as a property of PlayerInventory. If this is supposed to be a dynamic InventoryItem, use the `dynamic_item_pickup` script instead." % [node_display_name, item_property])

func consume(consumer: Node2D) -> void:
	if (consumer is Player):
		PlayerInventory.set(item_property, PlayerInventory.get(item_property) + amount)
		print("property_item_pickup.gd: Picked up item '%s'" % item_property)
		if single_use: collected_single_use_items.append(get_path())
		queue_free()
