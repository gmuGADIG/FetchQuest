class_name Player extends CharacterBody2D

static var instance: Player

@export var move_speed: float = 500.0
@export var sword_prefab: Resource          # Sword prefab resource to be instantiated
@export var raycast_length: float = 1000.0  # Maximum length of the raycast for throwing the sword
@export var throw_cooldown: float           # Time delay between sword throws

# Internal state variables
var timer: float = 10.0                     # Timer to track cooldown between throws
var can_throw: bool = true                  # Flag to determine if the player can throw the sword

signal died
signal health_changed(old_health: int)

@export var max_health: int = 3
var dead := false
var health := max_health:
	set(v):
		if dead: return

		var old_health := health
		health = v
		health_changed.emit(old_health)

		print("player's health is now: ", health)

		if health <= 0:
			dead = true
			died.emit()

func _ready() -> void:
	instance = self
	
# Handles player input, specifically mouse button events for throwing the sword
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_pos: Vector2 = get_viewport().canvas_transform.affine_inverse() * event.position
		if can_throw and timer >= throw_cooldown:
			timer = 0              # Reset the throw cooldown timer
			can_throw = false       # Prevent further throws until cooldown expires
			cast_ray_to_wall(mouse_pos)  # Cast a ray towards the mouse position to detect walls

# Called when the sword returns to the player, enabling another throw
func sword_returned() -> void:
	can_throw = true

# Casts a ray from the player to the target position to detect any wall collisions
func cast_ray_to_wall(target: Vector2) -> void:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(global_position, target)
	var result: Dictionary = space_state.intersect_ray(query)
	
	# Instantiate the sword and check if it hits a wall
	instantiate_sword(target, result and result.collider.is_in_group("Wall"))

# Instantiates the sword at the player's position and sets its properties based on the target and collision result
func instantiate_sword(target: Vector2, hit_wall: bool) -> void:
	var sword: Node = sword_prefab.instantiate()  # Create an instance of the sword prefab
	sword.thrower = self                         # Set the player as the thrower of the sword
	sword.target = target                        # Set the target position for the sword
	sword.position = position                    # Set the sword's initial position at the player
	
	# Calculate the distance between the player and the target
	var distance: float = (position - target).length()
	
	# If the ray hit a wall and the distance is within the sword's max range
	if hit_wall and distance <= sword.max_distance:
		sword.initial_speed = sqrt(-sword.acceleration * distance)  # Set initial speed for bouncing
		sword.acceleration = 0                                      # Stop acceleration for wall bounces
	else:
		sword.initial_speed = 0  # Set to 0 if there's no wall hit or out of range
	
	# Add the sword to the scene as a child of the player's parent node
	get_parent().add_child(sword)

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
