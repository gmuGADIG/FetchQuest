extends Node2D

## How long it takes until the mushroom explodes (set in the king scene)
var time_until_explosion:float = 3
## The sprite to switch to while exploding
var explosion_sprite:Texture2D = preload("res://enemy/king_boss/temp_art/explosion.png")
## Whether to check for the player or not
var check_for_player:bool = false

func _ready() -> void:
	# Explode after a timer
	await get_tree().create_timer(time_until_explosion).timeout
	explode()

func explode() -> void:
	# Change the sprite, start looking for the player, and die after 1 second
	check_for_player = true
	$Sprite2D.texture = explosion_sprite
	await get_tree().create_timer(1).timeout
	queue_free()

func _process(delta: float) -> void:
	# Hurt the player if it collides with the explosion
	if check_for_player and $PlayerDetector.overlaps_body(Player.instance):
		Player.instance.hurt(DamageEvent.new(1))
		queue_free()
