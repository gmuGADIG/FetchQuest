extends Node
enum {KEYBOARD_MODE, CONTROLLER_MODE}
@onready var mode := KEYBOARD_MODE

func _input(event) -> void:
	if event is InputEventKey || event is InputEventMouse:
		mode = KEYBOARD_MODE
		return
	if event is InputEventJoypadButton || event is InputEventJoypadMotion:
		mode = CONTROLLER_MODE

func isControllerMode() -> bool:
	return mode == CONTROLLER_MODE
	
func isKeyboardMode() -> bool:
	return mode == KEYBOARD_MODE
