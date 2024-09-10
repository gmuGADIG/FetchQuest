class_name Player extends CharacterBody2D

static var instance: Player

@export var move_speed: float = 500.0

func _ready() -> void:
	instance = self

## Returns a normalized vector in the direction the player is aiming
func get_aim() -> Vector2:
	match ControllerManager.mode:
		ControllerManager.ControlMode.KEYBOARD_MODE:
			return (get_global_mouse_position() - global_position).normalized()
		ControllerManager.ControlMode.CONTROLLER_MODE:
			return Input.get_vector("look_left", "look_right", "look_up", "look_down")
		_:
			assert(false) # we shouldn't be here!
			return Vector2.ZERO

func _physics_process(_delta: float) -> void:
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * move_speed
	move_and_slide()
