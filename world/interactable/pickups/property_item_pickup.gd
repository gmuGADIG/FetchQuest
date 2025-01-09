class_name PropertyItemPickup extends Item

## The property of the PlayerInventory class to increment, e.g. "bombs", "good_boy_points", "door_keys"
@export var item_property: StringName

## When collected, the value is incremented by this amount
@export var amount := 1

func _ready() -> void:
	super._ready()
	var node_display_name := get_parent().name+"/"+name
	assert(item_property != "", "Item '%s' has an empty inventory key!" % node_display_name)
	assert(item_property in PlayerInventory, "Item '%s' has key '%s', which does not exist as a property of PlayerInventory. If this is supposed to be a dynamic InventoryItem, use the `dynamic_item_pickup` script instead." % [node_display_name, item_property])

func consume(consumer: Node2D) -> void:
	super.consume(consumer)
	if (consumer is Player):
		PlayerInventory.set(item_property, PlayerInventory.get(item_property) + amount)
		print("property_item_pickup.gd: Picked up item '%s'" % item_property)
		queue_free()
