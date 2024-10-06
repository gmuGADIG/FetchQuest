extends Item
class_name BombPickup

@export var bomb_amount: int = 1

func consume(consumer: Node2D) -> void:
	if (consumer is Player):
		var player: Player = consumer as Player
		player.bombs+=bomb_amount
		queue_free()
