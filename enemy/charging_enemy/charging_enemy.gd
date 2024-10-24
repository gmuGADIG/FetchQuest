extends Enemy

@onready var sprite_normal: Sprite2D = $Sprite_Normal
@onready var sprite_activated: Sprite2D = $Sprite_Activated
@onready var sprite_stunned: Sprite2D = $Sprite_Stunned

## The contact damage that the charging enemy does when it is roaming.
@export var normal_damage: int = 1

## The contact damage that the charging enemy does when it is charging.
@export var charging_damage: int = 2

## The normal speed of the charging enemy. This applies to its roaming movement.
@export var normal_speed: float = 200

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

## Performs all the internal logic to set the charging enemy's state. Doing this
## in one place ensures that we always update everything we need to.
func set_own_state(state: EnemyState) -> void:
	# Only show one sprite for each state.
	# We could do this with one sprite that changes texture, but that's not
	# as straightforward to fix up if we have fewer textures later. Still,
	# could be refactored.
	sprite_normal.hide()
	sprite_activated.hide()
	sprite_stunned.hide()
	
	self.enemy_state = state
	
	match state:
		EnemyState.ROAMING:
			sprite_normal.show()
			movement_speed = normal_speed
			# Re-enable detection
			# NOTE: If the player detection component changes behavior this
			# could be problematic.
			$PlayerDetectionComponent.detecting = true
			
			damage = normal_damage
			
		EnemyState.AGRESSIVE:
			sprite_activated.show()
			movement_speed = charging_speed
			state_timer = charge_length
			
			damage = charging_damage
			
		EnemyState.STUNNED:
			sprite_stunned.show()
			# Can't move while stunned.
			movement_speed = 0
			state_timer = stun_length
			
			# Can't do contact damage when stunned.
			damage = 0

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
