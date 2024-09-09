extends Node

## Keeps track of the last used input device.

## The different types of input devices the user can use
enum ControlMode {
	KEYBOARD_MODE, 
	CONTROLLER_MODE
}

## The current control mode, determined by the last type of input device used by the player
@onready var mode := ControlMode.KEYBOARD_MODE

func _input(event: InputEvent) -> void:
	if event is InputEventKey || event is InputEventMouse:
		mode = ControlMode.KEYBOARD_MODE
		return
	if event is InputEventJoypadButton || event is InputEventJoypadMotion:
		mode = ControlMode.CONTROLLER_MODE

## Returns true if [member mode] equals [code]ControlMode.CONTROLLER_MODE[/code]
func is_controller_mode() -> bool:
	return mode == ControlMode.CONTROLLER_MODE
	
## Returns true if [member mode] equals [code]ControlMode.KEYBOARD_MODE[/code]
func is_keyboard_mode() -> bool:
	return mode == ControlMode.KEYBOARD_MODE
