extends Node2D

## Whether to check for the player or not
var exploding:bool = false

func explode() -> void:
	# Change the sprite, start looking for the player, and die after 1 second
	exploding = true
	$AnimatedSprite2D.play("explosion")
	await get_tree().create_timer(1).timeout
	queue_free()

func _process(delta: float) -> void:
	# Hurt the player if it collides with the explosion
	if exploding and $PlayerDetector.overlaps_body(Player.instance):
		Player.instance.hurt(DamageEvent.new(1))
		queue_free()
