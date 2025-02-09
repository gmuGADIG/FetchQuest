extends Area2D

## The amount of damage that the creep does per tick
@export var damage:int = 1
## The number of seconds that the creep will stay alive after reaching full size
@export var sustain_time:float = 2
## How fast the creep grows and shrinks
@export var growth:float = 1
## The maximum size that the creep grows to
@export var fully_grown_scale:Vector2 = Vector2.ONE * 1.5

func _ready() -> void:
	# Animate the creep to grow and shrink at the correct times/speeds
	var tween := create_tween()
	tween.tween_property(self, "scale", scale, 2.)
	tween.tween_property(self, "scale", Vector2.ZERO, 2.)
	await tween.finished
	queue_free()

	# tween.tween_property(self, "scale" , fully_grown_scale, abs(scale.distance_to(fully_grown_scale)) / growth)
	# tween.tween_property(self, "scale" , fully_grown_scale, sustain_time)
	# tween.tween_property(self, "scale" , Vector2.ZERO, abs(fully_grown_scale.distance_to(Vector2.ZERO)) / growth)
	# # Remove the creep once it shrinks away
	# tween.finished.connect(queue_free) 

func _process(_delta: float) -> void:
	if overlaps_body(Player.instance):
		Player.instance.hurt(DamageEvent.new(damage))
