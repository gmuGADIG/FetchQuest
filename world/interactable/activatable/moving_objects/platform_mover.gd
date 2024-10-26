extends Path2D

enum RepeatType {
	ONE_SHOT,
	BACK_AND_FORTH,
	REPEAT_FROM_START,
}

@export var repeat_type := RepeatType.ONE_SHOT
@export var speed := 100.0
@export var repeat_delay := 0.0 ## How many seconds the platform waits before repeating its path. Has no effect if repeat type is one-shot.

@onready var duration := curve.get_baked_length() / speed
@onready var path_follow: PathFollow2D = $PathFollow2D

var tween: Tween

func _ready() -> void:
	match repeat_type:
		RepeatType.ONE_SHOT:
			animate_position(0, 1)
		RepeatType.BACK_AND_FORTH:
			while true:
				await animate_position(0, 1)
				await get_tree().create_timer(repeat_delay).timeout
				await animate_position(1, 0)
				await get_tree().create_timer(repeat_delay).timeout
		RepeatType.REPEAT_FROM_START:
			while true:
				await animate_position(0, 1)
				await get_tree().create_timer(repeat_delay).timeout

func _process(delta: float) -> void:
	# note: movable_platform.gd requires the movement be done in the middle of a frame
	# i have no idea when tweens are processed by default, but it's not when it needs to be
	# so we pause the tweens and manually step them in process
	tween.custom_step(delta)

func animate_position(start_progress: float, end_progress: float) -> void:
	tween = get_tree().create_tween()
	tween.pause() # (see note in _process)
	path_follow.progress_ratio = start_progress
	tween.tween_property(path_follow, "progress_ratio", end_progress, duration)
	await tween.finished
