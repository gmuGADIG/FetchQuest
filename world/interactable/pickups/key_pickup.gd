extends Item

# Called when the node enters the scene tree for the first time.
func consume(consumer: Node2D) -> void:
	if (consumer is Player):
		PlayerInventory.door_keys += 1
		queue_free()
