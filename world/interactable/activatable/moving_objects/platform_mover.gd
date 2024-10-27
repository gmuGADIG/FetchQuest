@tool # make this a tool script to change the visible exported variables
extends Path2D

enum ActivateType {
	## The movable platform will move on it's own, repeating every [member repeat_delay] seconds.
	## [br]
	## [b]Note:[/b] Switches will still stop the platform when deactivated.
	AUTOMATIC,

	## Acts just like [code]ActivateType.AUTOMATIC[/code], but the platform only 
	## moves when a switch is activated.
	SEMI_AUTOMATIC,

	## The platform will not move until activated. When activated, it will move the entire path.
	FULL,

	## Same as [code]ActivateType.FULL[/code], but when [member repeat_type] is set to 
	## [code]RepeatType.BACK_AND_FORTH[/code], the platform will stop at the end of the path,
	## then travel back in reverse to the start when activated again.
	HALF_FULL,
}

enum RepeatType {
	## Travels the path once, and never again.
	ONE_SHOT,

	## Travels the path, then travels through the path in reverse, in a loop. Useful for
	## paths that are not loops, such as straight lines.
	BACK_AND_FORTH,

	## Goes through the path from start to finish in a loop. The platform will teleport
	## to the start when it repeats the path. Useful for paths that naturally are loops.
	REPEAT_FROM_START,
}

@export var activate_type := ActivateType.AUTOMATIC:
	set(v):
		activate_type = v

		notify_property_list_changed()
@export var repeat_type := RepeatType.REPEAT_FROM_START:
	set(v):
		repeat_type = v

		notify_property_list_changed()

## How fast the platform moves in pixels per second.
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var speed := 100.0
## How many seconds the platform waits before repeating its path. [br][br]
## Has no effect if [member repeat_type] is [code]RepeatType.ONE_SHOT[/code] or
## [member activate_type] is not [code]ActivateType.AUTOMATIC[/code] 
## or [code]ActivateType.SEMI_AUTOMATIC[/code].
var repeat_delay := 0.0 

@onready var duration := curve.get_baked_length() / speed
@onready var path_follow: PathFollow2D = $PathFollow2D

var tween: Tween

signal _activated
func activate() -> void:
	active = true
	_activated.emit()

var active := true
func deactivate() -> void:
	active = false

func _get_property_list() -> Array[Dictionary]:
	var result: Array[Dictionary] = []

	if activate_type in [ActivateType.AUTOMATIC, ActivateType.SEMI_AUTOMATIC] and repeat_type != RepeatType.ONE_SHOT:
		result.push_back({
			name = "repeat_delay",
			type = TYPE_FLOAT,
			hint_string = "suffix:s",
		})

	return result

func _wait(cycle_back: bool = false) -> void:
	match activate_type:
		ActivateType.AUTOMATIC, ActivateType.SEMI_AUTOMATIC:
			pass
		ActivateType.FULL:
			if not cycle_back:
				await _activated
		ActivateType.HALF_FULL:
			await _activated

func _ready() -> void:
	if Engine.is_editor_hint(): return

	if activate_type == ActivateType.SEMI_AUTOMATIC:
		await _activated

	match repeat_type:
		RepeatType.ONE_SHOT:
			await _wait()
			animate_position(0, 1)
		RepeatType.BACK_AND_FORTH:
			while true:
				await _wait()
				await animate_position(0, 1)
				await get_tree().create_timer(repeat_delay).timeout
				await _wait(true)
				await animate_position(1, 0)
				await get_tree().create_timer(repeat_delay).timeout
		RepeatType.REPEAT_FROM_START:
			while true:
				await _wait()
				await animate_position(0, 1)
				await get_tree().create_timer(repeat_delay).timeout

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return

	# note: movable_platform.gd requires the movement be done in the middle of a frame
	# i have no idea when tweens are processed by default, but it's not when it needs to be
	# so we pause the tweens and manually step them in process
	if tween != null and active:
		tween.custom_step(delta)

func animate_position(start_progress: float, end_progress: float) -> void:
	tween = get_tree().create_tween()
	tween.pause() # (see note in _process)
	path_follow.progress_ratio = start_progress
	tween.tween_property(path_follow, "progress_ratio", end_progress, duration)
	await tween.finished
