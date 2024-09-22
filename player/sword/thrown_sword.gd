extends CharacterBody2D
class_name ThrownSword

# Variables that are initialized at runtime
@onready var thrower: Player = Player.instance  ## Reference to the player who throws the sword
@onready var lifespan_timer: Timer = $LifespanTimer   ## The max lifespan of the sword
@onready var bounce_timer: Timer = $BounceTimer ## The time for the max time between bounces
@onready var sprite: Sprite2D = $Sprite2D       ## The sprite representing the sword

# Exported variables for external control and tuning in the editor
@export var throw_distance: float    ## Ideal throw distance. used to calculate the initial and max velocity
@export var acceleration: float      ## Acceleration factor applied to the sword movement

# Internal state variables
var returning: bool = false          ## Is the sword returning to the player?
var initial_speed: float             ## Initial speed for the sword throw
var num_bounces: int = 0             ## Number of bounces off walls or surfaces
var direction: Vector2               ## Direction vector of the sword
var player_dist: Vector2             ## Distance vector from the sword to the player
var local_acceleration: float        ## Local acceleration applied to the sword (adjustable)

## Signal emitted when the sword bounces, providing bounce intensity
signal sword_bounced(intensity: float)

## Called when the sword is ready (spawned)
func _ready() -> void:	
	lifespan_timer.timeout.connect(return_sword)
	bounce_timer.timeout.connect(return_sword)

## Called by the player as soon as the sword is thrown.
## Sets up initial speed and direction
func throw(throw_direction: Vector2) -> void:
	initial_speed = sqrt(2 * abs(acceleration) * throw_distance)
	direction = throw_direction.normalized() * initial_speed
	local_acceleration = acceleration
	velocity = direction.normalized() * initial_speed
	
## The sword's pickup_item function is called whenever an item interacts with it.
func pickup_item(item: Item) -> void:
	# Causes the item to follow the player
	item.glue_to(self, 20.0)
	
## Initiates the sword's return to the player
func return_sword() -> void:
	set_collision_mask_value(1, false)  # Disable collision with terrain
	returning = true                    # Mark the sword as returning
	local_acceleration = abs(acceleration)  # Adjust acceleration for return phase

## Handles the physics update process (called every frame)
func _physics_process(delta: float) -> void:	
	# Calculate distance between sword and player
	var old_player_dist: Vector2 = player_dist
	player_dist = thrower.position - position
	
	# Determine if the sword is close enough to the player using the dot product
	var cos_theta: float = player_dist.dot(old_player_dist) / (player_dist.length() * old_player_dist.length())
	if player_dist.length() <= 100 and cos_theta < 0 and returning:
		thrower.sword_returned.emit()  # Notify the player that the sword has returned
		queue_free()              # Remove the sword instance

	# Handle movement and acceleration while returning or still thrown
	if returning:
		direction = player_dist  # Update direction toward the player
		var speed: float = velocity.length() + local_acceleration * delta
		velocity = direction.normalized() * speed
	else:
		velocity += direction.normalized() * local_acceleration * delta
		if velocity.length() <= 100:
			return_sword()

	# Detect and handle collisions
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		_on_collision(collision)

## Handles sword ricochet off surfaces
func sword_bounce() -> void:
	num_bounces += 1     # Increment bounce count
	bounce_timer.start() # Reset bounce timer
	
	# Calculate max velocity based on acceleration and max distance
	var max_velocity: float = initial_speed if acceleration == 0 else sqrt(2 * abs(acceleration) * throw_distance)
	
	# Emit the bounce intensity signal
	sword_bounced.emit(velocity.length() / max_velocity)

## Handles collision detection and response
func _on_collision(collision: KinematicCollision2D) -> void:
	var collision_normal: Vector2 = collision.get_normal()  # Get the normal of the surface hit
	
	# Reflect the sword's velocity based on collision normal
	return_sword()
	velocity = velocity.bounce(collision_normal)
	direction = velocity  # Update direction after bounce
	sword_bounce()        # Handle ricochet logic
