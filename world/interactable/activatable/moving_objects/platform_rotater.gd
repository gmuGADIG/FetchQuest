extends Node2D

@export var angle := 360.0
@export var time := 1.0
@export var wait_time := 0.0

var tween: Tween

func _ready() -> void:
	start_rotation()

func _process(delta: float) -> void:
	if tween != null:
		tween.custom_step(delta)

func start_rotation() -> void:
	while true:
		tween = create_tween()
		tween.pause()
		tween.tween_property(self, "rotation_degrees", rotation_degrees + angle, time)
		await tween.finished
		await get_tree().create_timer(wait_time).timeout
