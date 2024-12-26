extends Node2D

## How long it takes until the mushroom explodes (set in the king scene)
var time_until_explosion:float = 3

var explosion_sprite:Texture2D = preload("res://enemy/king_boss/temp_art/explosion.png")

var check_for_player:bool = false

func _ready() -> void:
	await get_tree().create_timer(time_until_explosion).timeout
	explode()

func explode() -> void:
	check_for_player = true
	$Sprite2D.texture = explosion_sprite
	await get_tree().create_timer(1).timeout
	queue_free()

func _process(delta: float) -> void:
	if check_for_player and $PlayerDetector.overlaps_body(Player.instance):
		Player.instance.hurt(DamageEvent.new(1))
		queue_free()
