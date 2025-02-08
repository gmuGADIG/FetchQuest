class_name FrogBoss extends CharacterBody2D

@export var shockwave: Resource
@export var death_particle_effect: PackedScene
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: Player = Player.instance
@onready var action_cooldown: Timer = $ActionCooldown

@export var time_between_actions: float = 0.25
@onready var initial_time_between_actions := time_between_actions


signal health_changed
signal frog_die

@export var max_health: int = 15
@onready var health := max_health:
	set(value):
		health = value
		health_changed.emit()

var jump_time: float = 2.0
var hop_time: float = 0.5

var invincible: bool = false
var boss_phase: int = 1

var num_hops: int = 0
var num_jumps: int = 0
var total_actions: int = 0
var facing_direction: int = 1  # 1 for right, -1 for left

func activate() -> void:
	action_cooldown.start()
	action_cooldown.timeout.connect(_take_action)

func _take_action() -> void:
	var distance_to_player := player.global_position.distance_to(global_position)

	if boss_phase == 1 or boss_phase == 3:
		# if player is far away and we haven't jumped much
		if distance_to_player >= 700 and num_jumps <= 5:
			jump_to(player.global_position)
		# every three hops (except the first)
		elif num_hops >= 3:
			num_jumps = 0
			jump_to(player.global_position)
			num_hops = 0
		else:
			hop_to(player.global_position)
	else:
		jump_to(player.global_position)

	total_actions += 1

func hurt(damage_event: DamageEvent) -> void:
	if invincible or health <= 0:
		return

	health -= 1

	if health <= max_health / 2:
		if boss_phase == 1:
			jump_time /= 2
			hop_time /= 2
			time_between_actions = initial_time_between_actions / 2
			boss_phase = 2
			play_hurt_animation()
		elif boss_phase == 2:
			boss_phase = 3
			play_hurt_animation()

	print("Health of '%s' was lowered to %s/%s" % [get_path(), health, max_health])

	if health <= 0:
		on_death()
		return

	hit_flicker()

func hit_flicker() -> void:
	var enemy_normal_modulate: Color = sprite.modulate
	sprite.modulate = Color(0.4, 0.4, 0.4, 1)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = enemy_normal_modulate

func play_hurt_animation() -> void:
	invincible = true
	action_cooldown.paused = true
	if facing_direction == 1:
		sprite.play("frog_hurt_right")
	else:
		sprite.play("frog_hurt_left")
	await get_tree().create_timer(1.0).timeout
	invincible = false
	action_cooldown.paused = false

func on_death() -> void:
	print("Boss killed")
	action_cooldown.stop()
	invincible = true
	sprite.play("frog_die")
	frog_die.emit()

	if death_particle_effect:
		var particles: CPUParticles2D = death_particle_effect.instantiate()
		particles.global_position = global_position
		get_parent().add_child(particles)

	var death_timer: SceneTreeTimer = get_tree().create_timer(2.0)
	var elapsed_time: float = 0.0
	var original_position: Vector2 = sprite.position
	while death_timer.time_left > 0:
		sprite.position = original_position + Vector2(randi_range(-2, 2), randi_range(-2, 2))
		await get_tree().create_timer(0.05).timeout
	sprite.position = original_position
	queue_free()

func jump_to(target_position: Vector2) -> void:
	if velocity != Vector2.ZERO:
		return

	var move_direction: Vector2 = (target_position - global_position).normalized()
	update_facing_direction(move_direction)
	if facing_direction == 1:
		sprite.play("frog_jump_right")
	else:
		sprite.play("frog_jump_left")

	await get_tree().create_timer(jump_time / 6.0).timeout

	disable_hitbox()
	var starting_position: Vector2 = global_position
	velocity = Vector2.UP * 4000.0 / jump_time
	await get_tree().create_timer(5.0 / 12.0 * jump_time).timeout
	global_position = (global_position - starting_position) + target_position
	velocity = -velocity
	await get_tree().create_timer(5.0 / 12.0 * jump_time).timeout
	spawn_shockwave()
	velocity = Vector2.ZERO
	enable_hitbox()
	num_jumps += 1
	action_cooldown.stop()
	action_cooldown.start(jump_time + time_between_actions)

func spawn_shockwave() -> void:
	var land_shockwave: FrogShockwave = shockwave.instantiate()
	land_shockwave.global_position = global_position
	get_parent().add_child(land_shockwave)
	MainCam.shake(100, 0.2)

func disable_hitbox() -> void:
	collider.disabled = true

func enable_hitbox() -> void:
	collider.disabled = false

func hop_to(target_position: Vector2) -> void:
	if velocity != Vector2.ZERO:
		return

	var move_direction: Vector2 = (target_position - global_position).normalized()
	update_facing_direction(move_direction)
	if facing_direction == 1:
		sprite.play("frog_jump_right")
	else:
		sprite.play("frog_jump_left")

	num_hops += 1
	velocity = move_direction * 100 / hop_time
	await get_tree().create_timer(hop_time).timeout
	velocity = Vector2.ZERO
	action_cooldown.stop()
	action_cooldown.start(hop_time + time_between_actions)

func update_facing_direction(move_direction: Vector2) -> void:
	if move_direction.x > 0:
		facing_direction = 1
	elif move_direction.x < 0:
		facing_direction = -1

func _process(delta: float) -> void:
	move_and_slide()
	if velocity == Vector2.ZERO:
		if facing_direction == 1:
			sprite.play("default_right")
		else:
			sprite.play("default_left")
