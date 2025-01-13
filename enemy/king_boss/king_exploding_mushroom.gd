extends Node2D

## How long it takes until the mushroom explodes (set in the king scene)
var time_until_explosion:float = 3
## Whether to check for the player or not
var check_for_player:bool = false

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	# Explode after a timer
	await get_tree().create_timer(time_until_explosion).timeout
	explode()

func explode() -> void:
	# Change the sprite, start looking for the player, and die after 1 second
	check_for_player = true
	$AnimatedSprite2D.play("explosion")
	await get_tree().create_timer(1).timeout
	queue_free()

func _process(delta: float) -> void:
	# Hurt the player if it collides with the explosion
	if check_for_player and $PlayerDetector.overlaps_body(Player.instance):
		Player.instance.hurt(DamageEvent.new(1))
		queue_free()
