extends Item

@export var stamina_amount: int
# Called when the node enters the scene tree for the first time.
func consume(consumer: Node2D) -> void:
	if (consumer is Player):
		var player: Player = consumer as Player
		PlayerInventory.door_keys += 1
		queue_free()
