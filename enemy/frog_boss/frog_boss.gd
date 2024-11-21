extends CharacterBody2D

@export var shockwave: Resource
@onready var collider: CollisionShape2D = $"CollisionShape2D"
@onready var sprite: Sprite2D = $Sprite2D
@onready var player: Player = Player.instance
@onready var action_cooldown: Timer = $ActionCooldown

@export var time_between_actions: float = 0.25

signal health_changed

@export var max_health: int = 15
@onready var health := max_health :
	set(value):
		health = value
		health_changed.emit()
		
var jump_time: float = 2.0
var step_time: float = 0.5
		
var invincible: bool = false
var boss_phase: int = 1

var num_steps: int = 0

var in_step: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	action_cooldown.start()
	action_cooldown.timeout.connect(_take_action)
	
func _take_action() -> void:
	var distance_to_player: float = (player.global_position - global_position).length()
	
	match boss_phase:
		1:
			if (distance_to_player >= 600):
				jump_to(player.global_position)
				return
			if (num_steps != 0 and num_steps % 8 == 0):
				jump_to(player.global_position)
				num_steps += 1
			else:
				step_to(player.global_position)
				action_cooldown.start(step_time + time_between_actions)
		2:
			jump_to(player.global_position)
		3:
			if (distance_to_player >= 600):
				jump_to(player.global_position)
				return
			if (num_steps != 0 and num_steps % 6 == 0):
				jump_to(player.global_position)
				num_steps += 1
			else:
				step_to(player.global_position)
				action_cooldown.start(step_time + time_between_actions)
	
## Damages the enemy, killing it if its health drops below zero.
## This should be called by the player's attacks when they hit an enemy.
func hurt(damage_event: DamageEvent) -> void:
	if health <= 0: return # don't die twice

	health -= 1
	if (health <= max_health/2):
		if (boss_phase == 1):
			jump_time/=2
			step_time/=2
			time_between_actions/=2
			boss_phase = 2
		elif (boss_phase == 2):
			boss_phase = 3
	
	print("Enemy.gd: Health of '%s' was lowered to %s/%s" % [get_path(), health, max_health])

	if health <= 0:
		on_death()
		queue_free()
	
	hit_flicker() # This is put after the death/queue_free because the dimming response is unnecessary when the enemy is already responding via death.
	
func hit_flicker() -> void:
	var enemy_normal_modulate : Color = sprite.modulate
	sprite.modulate=Color(0.4,0.4,0.4,1)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = enemy_normal_modulate
	
func on_death() -> void:
	print("Boss killed")
	
func jump_to(target_position: Vector2) -> void:
	if (velocity != Vector2.ZERO):
		return
	var starting_position: Vector2 = global_position
	velocity = Vector2.UP * 4000.0/jump_time
	await get_tree().create_timer(jump_time/2.0).timeout
	global_position = (global_position - starting_position) + target_position
	velocity = -velocity
	await get_tree().create_timer(jump_time/2.0).timeout
	spawn_shockwave()
	velocity = Vector2.ZERO
	action_cooldown.stop()
	action_cooldown.start(jump_time + time_between_actions)
	
func spawn_shockwave() -> void:
	var land_shockwave: FrogShockwave = shockwave.instantiate()
	land_shockwave.global_position = global_position
	get_parent().add_child(land_shockwave)
	
func disable_hitbox() -> void:
	pass
	
func enable_hitbox() -> void:
	pass
	
func step_to(target_position: Vector2) -> void:
	if (velocity != Vector2.ZERO):
		return
	num_steps += 1
	var move_direction: Vector2 = (target_position - global_position).normalized()
	velocity = move_direction * 100/step_time
	await get_tree().create_timer(step_time).timeout
	velocity = Vector2.ZERO
	action_cooldown.stop()
	action_cooldown.start(step_time + time_between_actions)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_and_slide()
