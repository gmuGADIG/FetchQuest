extends Item
class_name HealthPickup

@export var health_amount: int
# Called when the node enters the scene tree for the first time.
func consume(consumer: Node2D) -> void:
	super.consume(consumer)
	if (consumer is Player):
		var player: Player = consumer as Player
		if (player.health < PlayerInventory.max_health):
			player.heal(health_amount)
			queue_free()
