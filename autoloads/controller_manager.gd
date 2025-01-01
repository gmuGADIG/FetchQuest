extends Node

## Keeps track of the last used input device.

## The different types of input devices the user can use
enum ControlMode {
	KEYBOARD_MODE, 
	CONTROLLER_MODE
}

## True: controller
## False: mouse and keyboard
var is_controller := false

## On controller, if the aim stick isn't held in any direction, the last non-zero aim will be used
var _last_nonzero_joystick_aim := Vector2.RIGHT

func _input(event: InputEvent) -> void:
	if event is InputEventKey || event is InputEventMouse:
		#Run once when switching modes
		if is_controller && Cursor.instance != null:
			Cursor.instance.mouse_mode();
		is_controller = false
		return
	if event is InputEventJoypadButton || event is InputEventJoypadMotion:
		#Run once when switching modes
		if not is_controller && Cursor.instance != null:
			Cursor.instance.controller_mode();
		is_controller = true

func _process(_delta: float) -> void:
	var current_aim := Input.get_vector("look_left", "look_right", "look_up", "look_down").normalized()
	if current_aim != Vector2.ZERO:
		_last_nonzero_joystick_aim = current_aim

## Only used for controllers. Returns the normalized aim direction.
## If no direction is held, returns the last direction that was held previously.
func get_joystick_aim() -> Vector2:
	return _last_nonzero_joystick_aim
	
