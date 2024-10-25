extends Node2D

## How long the pillar will fall for (set in the amalg pillars state)
var lifetime:float = 0

var check_for_player:bool = false
func _ready() -> void:
	# Animate the transparency towards 1
	var tween := create_tween()
	tween.tween_property($ShadowSprite,"modulate:a", 1.0, lifetime)
	await tween.finished
	check_for_player = true


func _process(delta: float) -> void:
	# Hurt the player once the animation is over
	if $PlayerDetector.overlaps_body(Player.instance) and check_for_player:
		Player.instance.hurt(DamageEvent.new(1))
		queue_free()
