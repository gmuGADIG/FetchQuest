class_name Player extends CharacterBody2D

static var instance: Player

@export var move_speed: float = 500.0

@export var max_health: int = 3
@onready var health := max_health

## On controller, if the aim stick isn't held in any direction, the last non-zero aim will be used
var last_aim_direction := Vector2.RIGHT







func _ready() -> void:
	instance = self

## Returns a normalized vector in the direction the player is aiming
func get_aim() -> Vector2:
	match ControllerManager.mode:
		ControllerManager.ControlMode.KEYBOARD_MODE:
			last_aim_direction = (get_global_mouse_position() - global_position).normalized()
		ControllerManager.ControlMode.CONTROLLER_MODE:
			var input := Input.get_vector("look_left", "look_right", "look_up", "look_down")
			if input != Vector2.ZERO:
				last_aim_direction = input.normalized()
		_:
			assert(false) # we shouldn't be here!
	print("Pain")
	return last_aim_direction

func _physics_process(_delta: float) -> void:
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * move_speed
	move_and_slide()

## Damages the player, lowering its health.
func hurt(damage: float) -> void:
	if health <= 0: return # don't die twice

	health -= damage
	print("player.gd: Health lowered to %s/%s" % [health, max_health])

	if health <= 0:
		pass # player death is not yet implemented
