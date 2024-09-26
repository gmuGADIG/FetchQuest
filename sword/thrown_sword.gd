extends CharacterBody2D
class_name ThrownSword

# Variables that are initialized at runtime
@onready var thrower: Player = Player.instance  # Reference to the player who throws the sword
@onready var lifespan: Timer = $Lifespan        # The max lifespan of the sword
@onready var bounce_timer: Timer = $BounceTimer # The time for the max time between bounces
@onready var sprite: Sprite2D = $Sprite2D       # The sprite representing the sword

# Exported variables for external control and tuning in the editor
@export var target: Vector2          # Target position for the sword to be thrown at
@export var acceleration: float      # Acceleration factor applied to the sword movement
@export var max_distance: float      # Maximum distance the sword can travel before returning
@export var min_throw_speed: float   # Minimum initial throw speed for the sword
@export var max_bounces: int         # Maximum allowed bounces before returning

# Internal state variables
var initial_speed: float = 0         # Speed of the sword when thrown
var returning: bool = false          # Is the sword returning to the player?
var num_bounces: int                 # Number of bounces off walls or surfaces
var direction: Vector2               # Direction vector of the sword
var player_dist: Vector2             # Distance vector from the sword to the player
var local_acceleration: float        # Local acceleration applied to the sword (adjustable)

# Signal emitted when the sword bounces, providing bounce intensity
signal bounce_sword(intensity: float)

# Called when the sword is ready (spawned)
func _ready() -> void:
	# Calculate initial direction and speed based on target and position
	direction = (target - position).normalized() * max_distance
	# direction = (target - position) + ((target-position).normalized() * 50) # If you want the sword to only go to the mouse location
	var distance: float = direction.length()
	
	# Calculate initial speed based on acceleration and distance to the target
	if initial_speed == 0:
		initial_speed = max(min_throw_speed, sqrt(-2 * acceleration * min(distance, max_distance)))
	
	# Set the sword's velocity based on direction and initial speed
	velocity = direction / distance * initial_speed
	local_acceleration = acceleration
	
	# Return the sword if it is out too long
	lifespan.timeout.connect(return_sword)
	bounce_timer.timeout.connect(return_sword)

# Makes items follow the boomerang
func pickup_item(item: Item) -> void:
	item.glue_to(self, 300.0)
	
# Initiates the sword's return to the player
func return_sword() -> void:
	set_collision_mask_value(1, false)  # Disable collision with certain layers (layer 1)
	returning = true                    # Mark the sword as returning
	local_acceleration = abs(acceleration)  # Adjust acceleration for return phase

# Detects input events (e.g., mouse clicks)
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released():
		return_sword()  # Return the sword when the player clicks

# Handles the physics update process (called every frame)
func _physics_process(delta: float) -> void:	
	# Calculate distance between sword and player
	var old_player_dist: Vector2 = player_dist
	player_dist = thrower.position - position
	
	# Determine if the sword is close enough to the player and returning using the dot product
	var cos_theta: float = player_dist.dot(old_player_dist) / (player_dist.length() * old_player_dist.length())
	if player_dist.length() <= 50 and cos_theta < 0.95 and returning:
		thrower.sword_returned()  # Notify the player that the sword has returned
		queue_free()              # Remove the sword instance

	# Handle movement and acceleration while returning or still thrown
	if returning:
		direction = player_dist  # Update direction toward the player
		var speed: float = velocity.length() + local_acceleration * delta
		if num_bounces > 0:
			velocity = (velocity + direction.normalized() * speed / 2.0).normalized() * speed
		else:
			velocity = direction.normalized() * speed
	else:
		velocity += direction.normalized() * local_acceleration * delta
		if velocity.length() <= 100:
			local_acceleration = abs(acceleration)  # Switch to return mode when speed is low
			returning = true

	# Detect and handle collisions
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		_on_collision(collision)

# Handles sword ricochet off surfaces
func sword_bounce() -> void:
	num_bounces += 1     # Increment bounce count
	bounce_timer.start() # Reset bounce timer
	
	# Calculate max velocity based on acceleration and max distance
	var max_velocity: float = velocity.length() * 1.2 if acceleration == 0 else sqrt(-2 * acceleration * max_distance)
	
	# Emit the bounce intensity signal
	bounce_sword.emit(velocity.length() / max_velocity)
	
	# If max bounces are reached, return the sword to the player
	if num_bounces > max_bounces:
		return_sword()

# Handles collision detection and response
func _on_collision(collision: KinematicCollision2D) -> void:
	if collision.get_collider().is_in_group("Wall"):
		var collision_normal: Vector2 = collision.get_normal()  # Get the normal of the surface hit
		local_acceleration = 0  # Stop acceleration on impact
		
		# Reflect the sword's velocity based on collision normal
		velocity = velocity.bounce(collision_normal)
		direction = velocity  # Update direction after bounce
		sword_bounce()        # Handle ricochet logic
