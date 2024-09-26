class_name Player extends CharacterBody2D

static var instance: Player

@onready var sword_cooldown: Timer = $SwordCooldown
@export var move_speed: float = 500.0
@export var sword_prefab: Resource          # Sword prefab resource to be instantiated
@export var max_throw_distance: float
@export var max_health: int = 3

@onready var health: int = max_health

# Internal state variables                
var sword_ready: bool = true                # Flag to determine if the player can throw the sword
var cooldown_ended: bool = true

signal died
signal health_changed(old_health: int)
signal throw_sword

## On controller, if the aim stick isn't held in any direction, the last non-zero aim will be used
var last_aim_direction := Vector2.RIGHT

func _ready() -> void:
	sword_cooldown.timeout.connect(cooldown_end)
	instance = self
	
func cooldown_end() -> void:
	cooldown_ended = true
	
func pickup_item(item: Item) -> void:
	print(item)

# Handles player input, specifically mouse button events for throwing the sword
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_pos: Vector2 = get_viewport().canvas_transform.affine_inverse() * event.position
		if sword_ready and cooldown_ended:
			var body: Node2D = cast_ray_to_wall(mouse_pos)  # Cast a ray towards the mouse position to detect walls
			if body:
				instantiate_sword(mouse_pos, body.is_in_group("Wall"))
				return
			instantiate_sword(mouse_pos, false)

# Called when the sword returns to the player, enabling another throw
func sword_returned() -> void:
	sword_ready = true

# Casts a ray from the player to the target position to detect any wall collisions
func cast_ray_to_wall(target: Vector2) -> Node2D:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(global_position, target)
	var result: Dictionary = space_state.intersect_ray(query)
	return null if result.is_empty() else result.collider

# Instantiates the sword at the player's position and sets its properties based on the target and collision result
func instantiate_sword(target: Vector2, hit_wall: bool) -> void:
	var sword: Node = sword_prefab.instantiate()  # Create an instance of the sword prefab
	sword.thrower = self                         # Set the player as the thrower of the sword
	sword.target = target                        # Set the target position for the sword
	sword.position = position                    # Set the sword's initial position at the player
	sword.max_distance = max_throw_distance
	
	# Calculate the distance between the player and the target
	var distance: float = (position - target).length()
	
	# If the ray hit a wall and the distance is within the sword's max range
	if hit_wall and distance <= sword.max_distance:
		sword.initial_speed = sqrt(-sword.acceleration * distance) * 0.85  # Set initial speed for bouncing
		sword.acceleration = 0                                      # Stop acceleration for wall bounces
	else:
		sword.initial_speed = 0  # Set to 0 if there's no wall hit or out of range
	
	# Add the sword to the scene as a child of the player's parent node
	get_parent().add_child(sword)
	sword_ready = false
	cooldown_ended = false
	sword_cooldown.start()
	throw_sword.emit()

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
