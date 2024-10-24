extends Node2D

var animation_speed:float = 1.5
var sustain_time:float = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween := create_tween()
	$EnterTimer.wait_time = animation_speed
	$EnterTimer.start()
	tween.tween_property($ShadowSprite,"modulate:a", 1.0, animation_speed)

func _process(delta: float) -> void:
	if $PlayerDetector.overlaps_body(Player.instance) and $EnterTimer.is_stopped():
		Player.instance.hurt(DamageEvent.new(1))
		queue_free()
