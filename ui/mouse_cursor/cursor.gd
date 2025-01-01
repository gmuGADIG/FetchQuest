extends Node2D
class_name Cursor

## Number of seconds before the cursor starts to fade after no controller input
@export var before_fade: float = .2
## Number of seconds the cursor fades over after no controller input
@export var fade_time: float = .5
## Curve to ease out the fading
@export_exp_easing var fade_ease: float = 1.


static var instance : Cursor

var time_since_controller_input: float = INF

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	instance = self

#Sets the cursor mode to controller, hides the actual cursor and replaces it with a sprite
func controller_mode() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	visible = true

#Sets the cursor mode to mouse, hides the fake cursor sprite and shows the real cursor
func mouse_mode() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = false

# if t < before_fade, then alpha = 1
# if before_fade < t < fade_time, then alpha is linearly going down over fade_time
# if t > fade_time, then alpha is zero
func alpha_from_time(t: float) -> float:
	t -= before_fade
	return clampf(remap(t, 0, fade_time, 1, 0), 0, 1)

func _process(delta: float) -> void:
	var input := Input.get_vector("look_left", "look_right", "look_up", "look_down").normalized()
	var is_moving := ControllerManager.is_controller and input != Vector2.ZERO
	print("input = ", input, " is_moving = ", is_moving, " t = ", time_since_controller_input, " alpha = ", modulate.a)

	if is_moving:
		rotation = ControllerManager.get_joystick_aim().angle()
		time_since_controller_input = 0
	else:
		time_since_controller_input += delta

	modulate.a = ease(alpha_from_time(time_since_controller_input), fade_ease)
