class_name Player extends CharacterBody2D

static var instance: Player

@export var move_speed: float = 500.0

@export var roll_speed: float = 2200.0

@export var max_health: int = 3
@onready var health := max_health

## On controller, if the aim stick isn't held in any direction, the last non-zero aim will be used
var last_aim_direction := Vector2.RIGHT

var rolling: bool = false
var roll_vector: Vector2 = Vector2(0, 0)

func get_roll_speed() -> float:
	# this can be edited to make the roll speed more dynamic
	# like along a curve or someting, might make it look nicer
	return roll_speed

# starts the player rolling (if they weren't already)
func start_roll() -> void:
	if (rolling): # obviously we don't want to roll twice over
		return
	
	rolling = true
	# get direction for the roll
	roll_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	# switch off collision with enemy bullets and the holes
	self.set_collision_mask_value(6, false)
	self.set_collision_mask_value(4, false)
	# make the timer go
	$RollTimer.start(0.15)
	#TODO: consume a stamina pip

# callback from roll timer. reverts changes made by start_roll
func stop_roll() -> void:
	rolling = false
	
	self.set_collision_mask_value(6, true)
	self.set_collision_mask_value(4, true)



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
	# normal movement input is not processed while rolling
	if (not rolling):
		velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * move_speed
	else:
		velocity = roll_speed * roll_vector
	
	if (Input.is_action_just_pressed("dog_roll")):
		start_roll()
	
	move_and_slide()

## Damages the player, lowering its health.
func hurt(damage: float) -> void:
	if health <= 0: return # don't die twice
	
	# don't take damage if rolling
	if (rolling):
		return
	
	health -= damage
	print("player.gd: Health lowered to %s/%s" % [health, max_health])

	if health <= 0:
		pass # player death is not yet implemented
