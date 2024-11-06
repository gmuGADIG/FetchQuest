extends CharacterBody2D
class_name ThrownSword

# Variables that are initialized at runtime
@onready var thrower: Player = Player.instance  ## Reference to the player who throws the sword
@onready var lifespan_timer: Timer = $LifespanTimer   ## The max lifespan of the sword
@onready var recall_timer: Timer = $RecallTimer ## The minimum time before the sword can be recalled

# Exported variables for external control and tuning in the editor
@export var throw_distance: float      ## Ideal throw distance. used to calculate the initial and max velocity
@export var acceleration: float        ## Acceleration factor applied to the sword movement
@export var max_bounces: int = 20      ## The maximum number of bounces the sword can take before returning
@export var max_bounce_distance: float ## The maximum distance the sword can bounce before returning to the player
@export var knockback_force: float = 500.0

# Internal state variables
var returning: bool = false          ## Is the sword returning to the player?
var initial_speed: float             ## Initial speed for the sword throw
var num_bounces: int = 0             ## Number of bounces off walls or surfaces
var direction: Vector2               ## Direction vector of the sword
var player_dist: Vector2             ## Distance vector from the sword to the player
var local_acceleration: float        ## Local acceleration applied to the sword (adjustable)
var last_bounce: Vector2             ## The last position the sword bounced from.

## Signal emitted when the sword bounces, providing bounce intensity
signal sword_bounced(intensity: float)

## Called when the sword is ready (spawned)
func _ready() -> void:	
	lifespan_timer.timeout.connect(return_sword)

## Called by the player as soon as the sword is thrown.
## Sets up initial speed and direction
func throw(throw_direction: Vector2) -> void:
	initial_speed = sqrt(2 * abs(acceleration) * throw_distance)
	direction = throw_direction.normalized() * initial_speed
	local_acceleration = acceleration
	velocity = direction.normalized() * initial_speed
	
	# apply player velocity on top
	var player_velocity := thrower.velocity
	if player_velocity.dot(velocity) > 0:
		# note: velocity is only added in the direction of the sword. if the player is
		# moving perpindicular, we don't want the sword to go sideways.
		# the speed is also clamped, mainly because dog rolls get the player's speed way too high
		velocity += (player_velocity.project(velocity) * .5).limit_length(500.0)
	
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
		queue_free()
		
	if num_bounces > 0 and (position - last_bounce).length() >= max_bounce_distance:
		return_sword()

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
		
func _process(_delta: float) -> void:
	if Input.is_action_just_released("attack"):
		if (recall_timer.is_stopped()):
			return_sword()
		else:
			recall_timer.timeout.connect(return_sword)

## Handles sword ricochet off surfaces
func sword_bounce() -> void:
	
	num_bounces += 1     # Increment bounce count
	last_bounce = position
	
	local_acceleration = -400
	# Calculate max velocity based on acceleration and max distance
	var max_velocity: float = initial_speed if acceleration == 0 else sqrt(2 * abs(acceleration) * throw_distance)
	
	# Emit the bounce intensity signal
	sword_bounced.emit(velocity.length() / max_velocity)
	
	# Return the sword if the maximum amount of bounces has happened
	if num_bounces > max_bounces:
		return_sword()

## Handles collision detection and response
func _on_collision(collision: KinematicCollision2D) -> void:
	if collision.get_collider().has_method("hurt"):
		collision.get_collider().hurt(DamageEvent.new(0, velocity.normalized()))
	var collision_normal: Vector2 = collision.get_normal()  # Get the normal of the surface hit
	velocity = velocity.bounce(collision_normal)
	direction = velocity  # Update direction after bounce
	sword_bounce()        # Handle ricochet logic

## Called by item.gd. Grabs the item and makes it follow the sword.
func pickup_item(item: Item) -> void:
	item.follow(self, 20.0)

func _on_damage_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Hittable"): return
	assert(body.has_method("hurt"), "Node '%s' was in the 'Hittable' group despite having no 'hurt' method." % body.get_path())
	body.hurt(DamageEvent.new(1, velocity.normalized() * knockback_force))
