extends Item

@export var inventory_key: String

func consume(consumer: Node2D) -> void:
	if (consumer is Player):
		PlayerInventory.add_quantity(inventory_key, 1)
		print("key_item_pickup.gd: Picked up item '%s'" % inventory_key)
		get_parent().queue_free()
