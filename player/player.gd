class_name Player extends CharacterBody2D

static var instance: Player

@export var move_speed: float = 500.0 ## Move speed in pixels per second
@export var max_health: int = 3 ## Max health and starting health
@onready var health: int = max_health: ## Current health
	set(value):
		health = value
		health_changed.emit()

@export var max_stamina: float = 3.0
@onready var stamina: float = max_stamina
@onready var force_applied: Vector2 = Vector2.ZERO ## All external forces applied
@export var stamina_recovery_rate: float = 1.0

@export var knockback_friction: float = 5.0 ## How fast the player slows down from knockback
var active_sword: ThrownSword ## The active thrown sword. Null if the player is currently holding the sword

@onready var bombScene := preload("bomb.tscn")

## On controller, if the aim stick isn't held in any direction, the last non-zero aim will be used
var last_aim_direction := Vector2.RIGHT

var rolling: bool = false
var roll_vector: Vector2 = Vector2(0, 0)
var rollTimer: float = 0.25
@export var roll_speed: float = 1000.0

signal health_changed

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
	var endRollTime: float = rollTimer/5
	var variableB: float = 0.1
	var variableX: float = rollTimer-$RollTimer.time_left
	if($RollTimer and $RollTimer.time_left>endRollTime):
		var sinConst: float = sin(variableX)/(sqrt(variableB**2+sin(variableX)**2))
		return roll_speed * 2.5 * sinConst
#		var sinConst: float = PI/rollTimer #shortens sin function to match timer
#		return roll_speed * 2.5 * sin(sinConst*(rollTimer-$RollTimer.time_left))
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
	# switch off collision with enemy bullets and the holes
	self.set_collision_mask_value(6, false)
	self.set_collision_mask_value(4, false)
	# make the timer go
	$RollTimer.start(rollTimer)

# callback from roll timer. reverts changes made by start_roll
func stop_roll() -> void:
	rolling = false
	
	self.set_collision_mask_value(6, true)
	self.set_collision_mask_value(4, true)

## Called when the player spawns in
func _ready() -> void:
	instance = self
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("speak"):
		if !$Speak.on_cooldown():
			$Speak.speak()
	
	if Input.is_action_just_pressed("attack"):
		if active_sword == null:
			throw_sword()

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

func _physics_process(delta: float) -> void:
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * move_speed
	if($Speak.is_speaking()):
		velocity *= $Speak.movement_multiplier
	# normal movement input is not processed while rolling
	if (not rolling):
		velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * move_speed
	else:
		velocity = get_roll_speed() * roll_vector
	
	recover_stamina(delta)
	
	if (Input.is_action_just_pressed("dog_roll")):
		start_roll()
	
	velocity += force_applied 	
	force_applied = force_applied.lerp(Vector2.ZERO, delta * knockback_friction)
	move_and_slide()

func _input(event: InputEvent) -> void:
	#TODO: REMOVE THIS
	PlayerInventory.bombs = 314159
	
	if(event.is_action_pressed("throw_bomb")):
		if PlayerInventory.bombs > 0:
			var bombInstance := bombScene.instantiate()
			bombInstance.position = position
			bombInstance.set_velocity(get_aim() * 1000)
			add_sibling(bombInstance)
			PlayerInventory.bombs-=1

## Damages the player, lowering its health.
func hurt(damage_event: DamageEvent) -> void:
	if health <= 0: return # don't die twice
	if rolling: return # immune while rolling
	
	health -= damage_event.damage
	add_force(damage_event.knockback)
	print("player.gd: Health lowered to %s/%s" % [health, max_health])
	
	if health <= 0:
		get_tree().change_scene_to_file("uid://b6jsq4syp4v0w")
		pass # player death is not yet implemented

## Increases the player, not exceeding its max health
func heal(gained: int) -> void:
	if health >= max_health: return
	
	health = move_toward(health, max_health, gained)
	print("player.gd: Health raised to %s/%s" % [health, max_health])

## Apply a force to the player. Generally, a good magnitude is around 500 to 1000
func add_force(force: Vector2) -> void:
	force_applied += force
	
func _pickup_item(item: Item) -> void:
	item.consume(self)
	
