class_name Player extends CharacterBody2D

static var instance: Player

@export var move_speed: float = 500.0 ## Move speed in pixels per second
@export var max_health: int = 3 ## Max health and starting health

@onready var health: int = max_health ## Current health
var active_sword: ThrownSword ## The active thrown sword. Null if the player is currently holding the sword

## Called when the player spawns in
func _ready() -> void:
	instance = self

## Returns a normalized vector in the direction the player is aiming.
func get_aim() -> Vector2:
	if ControllerManager.is_controller:
		return ControllerManager.get_joystick_aim()
	else:
		return global_position.direction_to(get_global_mouse_position())
	
## Instantiates a sword and throws it in the aim direction
func throw_sword() -> void:
	var sword: ThrownSword = preload("res://player/sword/thrown_sword.tscn").instantiate()
	active_sword = sword
	sword.position = get_parent().to_local(self.global_position)
	add_sibling(sword)
	sword.throw(get_aim())

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		if active_sword == null:
			throw_sword()

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
