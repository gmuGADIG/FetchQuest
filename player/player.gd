class_name Player extends CharacterBody2D

static var instance: Player

@onready var sword_cooldown: Timer = $SwordCooldown ## The timer object that stores the cooldown for throwing the sword
@export var move_speed: float = 500.0               ## The player's move speed (in pixels per second)
@export var sword_prefab: Resource                  ## Sword prefab resource to be instantiated
@export var max_throw_distance: float               ## The player's max throw distance (in pixels)
@export var max_health: int = 3                     ## The player's max health

@onready var health: int = max_health               ## The player's health value
var sword_ready: bool = true                        ## Flag to determine if the player can throw the sword
var active_sword: ThrownSword                       ## The currently active player sword

signal died                            ## This signal is emitted when the player dies.     
signal health_changed(old_health: int) ## This signal is emitted when the player's health changes.
signal sword_thrown                    ## This signal is emitted when the player throws their sword.
signal sword_returned                  ## This signal is emitted when the player's sword returns.

## Called when the player spawns in
func _ready() -> void:
	instance = self
	sword_returned.connect(on_sword_return)

## Returns a normalized vector in the direction the player is aiming.
func get_aim() -> Vector2:
	if ControllerManager.is_controller:
		return ControllerManager.get_joystick_aim()
	else:
		return global_position.direction_to(get_global_mouse_position())

## This function gets called when the player's sword is returned after a throw
func on_sword_return() -> void:
	active_sword = null

## The player's pickup_item function is called when they make contact with an item
func pickup_item(item: Item) -> void:
	print(item)
	
## Throws a given sword instance. Mainly used to reset cooldowns
func throw_sword(sword: ThrownSword) -> void:
	sword_ready = false
	sword_cooldown.start()
	active_sword = sword
	get_parent().add_child(sword)

## Casts a ray from the player to the target position to detect any wall collisions
func cast_ray_to_wall(direction: Vector2) -> Node2D:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var destination: Vector2 = global_position + (direction.normalized() * max_throw_distance)
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(global_position, destination)
	var result: Dictionary = space_state.intersect_ray(query)
	return null if result.is_empty() else result.collider

## Instantiates the sword at the player's position and sets its properties based on the target and collision result
func instantiate_sword(target: Vector2, as_direction: bool = true) -> ThrownSword:
	var sword: ThrownSword = sword_prefab.instantiate()  # Create an instance of the sword prefab
	sword.thrower = self                         # Set the player as the thrower of the sword
	sword.max_distance = max_throw_distance
	sword.position = position
	var body: Node2D = cast_ray_to_wall(target)
		
	# If the target is being treated as a direction, not a destination
	if as_direction:
		sword.setup_in_direction(target, max_throw_distance)
	else:
		sword.setup_to_target(target)
		
	# If the ray hit a wall
	if body and body.is_in_group("Wall"):
		var distance: float = (position - body.position).length()
		sword.initial_speed = sqrt(-sword.acceleration * distance)  # Set initial speed for bouncing
		sword.local_acceleration = 0

	return sword

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		if active_sword == null:
			if sword_cooldown.is_stopped():
				var sword: ThrownSword = instantiate_sword(get_aim())
				throw_sword(sword)
		else:
			active_sword.return_sword()

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
