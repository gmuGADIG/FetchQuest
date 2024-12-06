class_name Player extends CharacterBody2D

static var instance: Player

@export var move_speed: float = 500.0 ## Move speed in pixels per second
@export var max_health: int = 6 ## Max health and starting health
@export var bomb_throw_speed: float = 1000.0 ## Bombs are thrown with this much velocity
@export var max_stamina: float = 3.0
@export var stamina_recovery_rate: float = 1.0 ## How much stamina
@export var knockback_friction: float = 5.0 ## How fast the player slows down from knockback
@export var roll_speed: float = 1000.0


@onready var health: int = max_health: ## Current health
	set(value):
		health = value
		health_changed.emit()

@onready var stamina: float = max_stamina:
	set(value):
		stamina = value
		stamina_changed.emit()

@onready var force_applied: Vector2 = Vector2.ZERO ## All external forces applied

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var hole_detector: Node2D = $HoleDetector
@onready var roll_sound: AudioStreamPlayer = %RollingSound

var bomb_scene := preload("bomb.tscn")

# TODO: handle different dog sprites
@onready var _animated_sprite := %Skin1

var active_sword: ThrownSword ## The active thrown sword. Null if the player is currently holding the sword

## On controller, if the aim stick isn't held in any direction, the last non-zero aim will be used
var last_aim_direction := Vector2.RIGHT

var invincible: bool = false

var facing_right: bool = true;
var rolling: bool = false
var roll_vector: Vector2 = Vector2(0, 0)
var roll_timer: float = 0.25

signal health_changed
signal stamina_changed

# returns true if a stamina pip was used, false otherwise
func expend_stamina() -> bool:
	var int_stamina: int = int(stamina)
	if int_stamina < 1:
		return false

	stamina = max(float(int_stamina - 1), 0.0)
	return true

# recovers stamina by stamina_recovery_rate up to the max
func recover_stamina(delta: float) -> void:
	stamina += delta * stamina_recovery_rate
	if stamina > max_stamina:
		stamina = max_stamina

#Changes speed to fit a sin wave for smoother rolls
func get_roll_speed() -> float:
	var endRollTime: float = roll_timer/5
	var variableB: float = 0.1
	var variableX: float = roll_timer-$RollTimer.time_left
	if($RollTimer and $RollTimer.time_left>endRollTime):
		var sinConst: float = sin(variableX)/(sqrt(variableB**2+sin(variableX)**2))
		return roll_speed * 2.5 * sinConst
#		var sinConst: float = PI/roll_timer #shortens sin function to match timer
#		return roll_speed * 2.5 * sin(sinConst*(roll_timer-$RollTimer.time_left))
	else:
		return roll_speed

# starts the player rolling (if they weren't already)
func start_roll() -> void:
	if (rolling): # obviously we don't want to roll twice over
		return

	if (not expend_stamina()):
		return

	rolling = true
	# get direction for the roll
	roll_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	if(not facing_right):
		_animated_sprite.play("Artie_Roll_Left")
	else:
		_animated_sprite.play("Artie_Roll_Right")
	# switch off collision with enemy bullets and the holes
	self.set_collision_mask_value(6, false)
	hole_detector.enabled = false

	# make the timer go
	$RollTimer.start(roll_timer)
	
	# play sound
	roll_sound.play()

# callback from roll timer. reverts changes made by start_roll
func stop_roll() -> void:
	_animated_sprite.stop()
	rolling = false
	
	hole_detector.enabled = true

	self.set_collision_mask_value(6, true)

func _init() -> void:
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
	if Input.is_action_just_pressed("speak"):
		if !$Speak.on_cooldown():
			$Speak.speak()
			if(not facing_right):
				_animated_sprite.play("Artie_Bark_Left")
			else:
				_animated_sprite.play("Artie_Bark_Right")

	if Input.is_action_just_pressed("attack"):
		if active_sword == null:
			throw_sword()

	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * move_speed
	if(velocity != Vector2.ZERO):
		if(velocity.x < 0):
			facing_right = false
		else:
			facing_right = true
	if($Speak.is_speaking()):
		velocity *= $Speak.movement_multiplier
	# normal movement input is not processed while rolling
	if (not rolling):
		velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * move_speed
	else:
		velocity = get_roll_speed() * roll_vector

	recover_stamina(delta)

	if (Input.is_action_just_pressed("dog_roll")):
		_animated_sprite.stop()
		start_roll()
		
	if(not rolling && not $Speak.is_speaking()):
		if(velocity == Vector2.ZERO):
			if(facing_right):
				_animated_sprite.play("Artie_Base_Right")
			else:
				_animated_sprite.play("Artie_Base_Left")
		elif(not facing_right):
			_animated_sprite.play("Artie_Walk_Left")
		else:
			_animated_sprite.play("Artie_Walk_Right")
	velocity += force_applied

	force_applied = force_applied * exp(-knockback_friction * delta)
	if force_applied.length() < 10: force_applied = Vector2.ZERO

	move_and_slide()
	
	handle_one_ways()

func _input(event: InputEvent) -> void:
	#TODO: REMOVE THIS
	PlayerInventory.bombs = 314159

	if(event.is_action_pressed("throw_bomb")):
		if PlayerInventory.bombs > 0:
			var bomb_instance := bomb_scene.instantiate()
			bomb_instance.position = position
			bomb_instance.velocity = get_aim() * bomb_throw_speed
			add_sibling(bomb_instance)
			PlayerInventory.bombs-=1

## Called every frame after move_and_slide
## Checks for collision with one-way tiles and moves accordingly
func handle_one_ways() -> void:
	if rolling: return
	
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var one_way := collision.get_collider() as OneWay
		if one_way != null:
			var player_direction := -collision.get_normal()
			if player_direction == one_way.direction:
				jump_over_one_way(one_way.direction)
				break # prevent jumping twice in a frame

func jump_over_one_way(direction: Vector2) -> void:
	var jump_to := position + OneWay.JUMP_SIZE * direction
	
	process_mode = PROCESS_MODE_DISABLED
	
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", jump_to, .5)
	
	await tween.finished
	process_mode = PROCESS_MODE_INHERIT
	

## Damages the player, lowering its health.
func hurt(damage_event: DamageEvent) -> void:
	if health <= 0: return # don't die twice
	if rolling: return # immune while rolling
	if invincible: return # immune if invincible is true for i frames
	health -= damage_event.damage
	add_force(damage_event.knockback)
	print("player.gd: Health lowered to %s/%s" % [health, max_health])

	if health <= 0:
		get_tree().change_scene_to_file.call_deferred("uid://b6jsq4syp4v0w")

	activate_iframes()

## Increases the player, not exceeding its max health
func heal(gained: int) -> void:
	if health >= max_health: return

	health = move_toward(health, max_health, gained) as int
	print("player.gd: Health raised to %s/%s" % [health, max_health])

## Apply a force to the player. Generally, a good magnitude is around 500 to 1000
func add_force(force: Vector2) -> void:
	force_applied += force

## Called by item.gd. Consumes the item
func pickup_item(item: Item) -> void:
	item.consume(self)

func fall_in_hole() -> void:
	hurt(DamageEvent.new(1))
	# todo: play animation
	position = hole_detector.last_safe_position

func activate_iframes() -> void:
	invincible = true
	animation_player.play("hurt_flash")
	await animation_player.animation_finished
	invincible = false
