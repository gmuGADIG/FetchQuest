extends Enemy

@onready var sprite: AnimatedSprite2D = $ChargingAnimation

## The contact damage that the charging enemy does when it is charging.
@export var charging_damage: int = 2

## The charging speed of the enemy. Applies only to its charging movement. To
## make it charge at high speed, make this much higher than the normal speed.
@export var charging_speed: float = 500

## The length of the charge windup animation in seconds.
@export var charge_windup: float = 0.7

## The length of the charge attack in seconds.
@export var charge_length: float = 1.5

## The length of the stun at the end of the charge in seconds.
@export var stun_length: float = 2.0

# Unit vector storing the current direction we're charging.
var charge_direction: Vector2

## Timer that keeps track of how long we've been charging or stunned.
## Once it hits 0, we automatically change state.
var state_timer: float = 0.0

## While we're winding up, don't move.
## NOTE: Don't bother setting this as a setting, this is just exported so
## that it can be set by the animation player.
@export var is_winding_up: bool = false

## Performs all the internal logic to set the charging enemy's state. Doing this
## in one place ensures that we always update everything we need to.
func set_own_state(state: EnemyState) -> void:
	# Only show one sprite for each state.
	# We could do this with one sprite that changes texture, but that's not
	# as straightforward to fix up if we have fewer textures later. Still,
	# could be refactored.
	
	self.enemy_state = state
	
	match state:
		EnemyState.ROAMING:
			_set_idle_animation()
			# Re-enable detection
			# NOTE: If the player detection component changes behavior this
			# could be problematic.
			$PlayerDetectionComponent.detecting = true
			
		EnemyState.AGRESSIVE:
			_set_charge_animation()
			state_timer = charge_length
			
		EnemyState.STUNNED:
			_set_idle_animation()
			state_timer = stun_length

func _set_charge_animation() -> void:
	if charge_direction.y > 0:
		sprite.play("charging down")
	elif charge_direction.x < 0:
		sprite.play("charging left")
	elif charge_direction.x > 0:
		sprite.play("charging right")

func _set_idle_animation() -> void:
	if velocity.x < 0 and velocity.y < 0:
		if velocity.x < velocity.y:
			sprite.play("left idle")
		else:
			sprite.play("down idle")
	elif velocity.x > 0 and velocity.y < 0:
		if velocity.x > (velocity.y * -1):
			sprite.play("right idle")
		else:
			sprite.play("down idle")
	elif velocity.x < 0 and velocity.y > 0:
		if (velocity.x * -1) > velocity.y:
			sprite.play("left idle")
		else:
			sprite.play("up idle")
	elif velocity.x > 0 and velocity.y > 0:
		if velocity.x > velocity.y:
			sprite.play("right idle")
		else:
			sprite.play("up idle")

func _player_detected() -> void:
	# When we detect the player, immediately charge.
	# The animation player handles the animation, and will call us back later.
	$AnimationPlayer.play("Charge")
	
	# Stop detecting players until we reset back to the idle state
	$PlayerDetectionComponent.detecting = false
	
	# Grab our target position when we start the charge animation.
	charge_direction = global_position.direction_to(Player.instance.global_position)

func _ready() -> void:
	super()
	
	# The enemy starts out in Roaming state.
	set_own_state(EnemyState.ROAMING)
	
	# Just in case we somehow end up in wrong state, make the direction sensible.
	charge_direction = Vector2.LEFT
	
	$PlayerDetectionComponent.player_detected.connect(_player_detected)
	
	# To use the charge windup speed, we scale the speed of the animation
	# player. This animation player is ONLY used to do the Charge animation.
	$AnimationPlayer.speed_scale = 1.0 / charge_windup
	
## Called by the AnimationPlayer when the Charge animation finishes. At that point,
## we change to Aggressive mode which performs the charging logic.
func _anim_charge_now() -> void:
	set_own_state(EnemyState.AGRESSIVE)
	
# Override the aggressive prtgodessing to do nothing but count down the amount of
# time left in the charge. This is important because the actual behavior is
# just to charge in a straight line.
func _process_agressive(delta: float) -> void:
	state_timer -= delta
	if state_timer <= 0:
		set_own_state(EnemyState.STUNNED)
	
# TODO: Once the base Enemy class has some logic here, see whether we should
# we should call super or something similar.
func _process_stunned(delta: float) -> void:
	state_timer -= delta
	if state_timer <= 0:
		set_own_state(EnemyState.ROAMING)
		
# When we're in the aggressive mode, we want to charge in a straight line without
# using navigation. So, we have to override physics process.
func _physics_process(delta: float) -> void:
	if enemy_state == EnemyState.AGRESSIVE:
		velocity = charge_direction * charging_speed
		move_and_slide()
		
		# If we hit a wall, this will be greater than 0. In that case, we
		# end the charge early.
		if get_slide_collision_count() > 0:
			set_own_state(EnemyState.STUNNED)
	else:
		super(delta)

func _process(delta: float) -> void:
	super(delta)
	
	match enemy_state:
		EnemyState.AGRESSIVE:
			_set_charge_animation()
		_:
			_set_idle_animation()

func _get_contact_damage() -> int:
	match enemy_state:
		EnemyState.ROAMING:
			return damage
		EnemyState.AGRESSIVE:
			return charging_damage
		# Can't do contact damage while stunned.
		_:
			return 0
			
func _get_movement_speed() -> float:
	match enemy_state:
		EnemyState.ROAMING:
			# Don't move while we're winding up
			if is_winding_up:
				return 0
			# Otherwise roam at the base "movement_speed"
			return movement_speed
		EnemyState.AGRESSIVE:
			return charging_speed
		# Can't move while stunned.
		_:
			return 0
