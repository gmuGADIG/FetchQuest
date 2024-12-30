class_name KingThrownScepter extends CharacterBody2D

var thrower:King

# Exported variables for external control and tuning in the editor
@export var throw_distance: float      ## Ideal throw distance. used to calculate the initial and max velocity
@export var acceleration: float        ## Acceleration factor applied to the sword movement
@export var max_bounces: int = 20      ## The maximum number of bounces the sword can take before returning
@export var max_bounce_distance: float ## The maximum distance the sword can bounce before returning to the King
@export var knockback_force: float = 500.0

# Internal state variables
var returning: bool = false          ## Is the sword returning to the King?
var initial_speed: float             ## Initial speed for the sword throw
var num_bounces: int = 0             ## Number of bounces off walls or surfaces
var direction: Vector2               ## Direction vector of the sword
var king_dist: Vector2             ## Distance vector from the sword to the King
var local_acceleration: float        ## Local acceleration applied to the sword (adjustable)
var last_bounce: Vector2             ## The last position the sword bounced from.

## Signal emitted when the sword bounces, providing bounce intensity
signal scepter_bounced(intensity: float)

## Signal emitted when the scepter returns, allowing for the next scepter to be thrown
signal scepter_returned

## Signal emitted when the scepter is barked at
signal scepter_barked(position: Vector2)

func _ready() -> void:
	$LifespanTimer.timeout.connect(return_scepter)

func throw(throw_direction:Vector2) -> void:
	initial_speed = sqrt(2 * abs(acceleration) * throw_distance)
	direction = throw_direction.normalized() * initial_speed
	local_acceleration = acceleration
	velocity = direction.normalized() * initial_speed

func return_scepter() -> void:
	collision_mask = 0 # Disable collision with terrain
	returning = true                    # Mark the sword as returning
	local_acceleration = abs(acceleration)  # Adjust acceleration for return phase

func _physics_process(delta: float) -> void:
	# Calculate distance between sword and king
	var old_king_dist: Vector2 = king_dist
	king_dist = thrower.position - position
	
	# Determine if the sword is close enough to the king using the dot product
	var cos_theta: float = king_dist.dot(old_king_dist) / (king_dist.length() * old_king_dist.length())
	if king_dist.length() <= 100 and cos_theta < 0 and returning:
		scepter_returned.emit()
		queue_free()

	if num_bounces > 0 and (position - last_bounce).length() >= max_bounce_distance:
		return_scepter()

	# Handle movement and acceleration while returning or still thrown
	if returning:
		direction = king_dist  # Update direction toward the king
		var speed: float = velocity.length() + local_acceleration * delta
		velocity = direction.normalized() * speed
	else:
		velocity += direction.normalized() * local_acceleration * delta
		if velocity.length() <= 100:
			return_scepter()

	# Detect and handle collisions
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		_on_collision(collision)

## Handles sword ricochet off surfaces
func sword_bounce() -> void:
	
	num_bounces += 1     # Increment bounce count
	last_bounce = position
	
	local_acceleration = -400
	# Calculate max velocity based on acceleration and max distance
	var max_velocity: float = initial_speed if acceleration == 0 else sqrt(2 * abs(acceleration) * throw_distance)
	
	# Emit the bounce intensity signal
	scepter_bounced.emit(velocity.length() / max_velocity)
	
	# Return the sword if the maximum amount of bounces has happened
	if num_bounces > max_bounces:
		return_scepter()

func _on_collision(collision: KinematicCollision2D) -> void:
	if collision.get_collider().has_method("hurt"):
		collision.get_collider().hurt(DamageEvent.new(0, velocity.normalized()))

	var collision_normal: Vector2 = collision.get_normal()  # Get the normal of the surface hit
	velocity = velocity.bounce(collision_normal)

	direction = velocity  # Update direction after bounce
	sword_bounce()        # Handle ricochet logic

	var collider := collision.get_collider()
	if collider is CollisionObject2D and collider.get_collision_layer_value(10):
		return_scepter()

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.has_method("hurt"):
		body.hurt(DamageEvent.new(1, velocity.normalized() * knockback_force))

func barked() -> void:
	scepter_barked.emit(global_position)
	queue_free()
