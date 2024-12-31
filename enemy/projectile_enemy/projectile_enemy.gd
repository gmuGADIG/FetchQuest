extends Enemy

#Attack speed (time between shots)
@export var attack_speed : float = 1.0
#Standstill time (time after an attack before the enemy can move again)
@export var standstill_time : float = 0.5
#How close the enemy must be to start shooting.
@export var attack_range : float = 1.3
#Accuracy
@export_range(0, 90) var attack_spread : float = 0
#Shoot animation length
@export var animation_length : float = 1


var can_shoot : bool = true
var can_move : bool = true


static var projectile :PackedScene = preload("res://enemy/projectile_enemy/projectile/projectile.tscn")

func _ready() -> void:
	super._ready()
	$AnimatedSprite2D.animation="fire_right"
	
	assert(projectile != null)
	$Shooter/CooldownTimer.wait_time = attack_speed
	$Shooter/AttackRange/CollisionShape2D.scale *= attack_range


func _process(delta: float) -> void:
	super._process(delta)
	if can_shoot:
		for body: Node2D in $"Shooter/AttackRange".get_overlapping_bodies():
			if body is Player:
				print("Found Player")
				shoot()
				
func _physics_process(delta: float) -> void:
	if can_move:
		super._physics_process(delta)
		animateWalk()
		
		
	
	#
#func _enter_tree() -> void:
	## apparently, taking a timer out of and back into a tree breaks it, since autostart is disabled after entering the tree
	## since enemies are unloaded and reloaded by taking them out of the tree, we need to work around this
	#$Shooter/CooldownTimer.start.call_deferred()


	

func shoot() -> void:
	var proj : Node2D = projectile.instantiate()
	proj.global_position = self.global_position
	# Finds the player and rotates the bullet to be pointing towards their position
	proj.look_at(get_tree().get_first_node_in_group("Player").position)
	# Adds some spread
	proj.global_rotation_degrees += randf()*attack_spread *2 - attack_spread
	get_parent().add_sibling(proj)
	can_shoot = false
	can_move = false
	$Shooter/StandStillTimer.start(standstill_time)
	$Shooter/CooldownTimer.start(attack_speed)
	
	animateShooting()

func enable_movement() -> void:
	can_move = true

func end_cooldown() -> void:
	can_shoot = true
	pass

func animateWalk() -> void:
	if velocity == Vector2.ZERO: return
	var best: Vector2
	var best_dot := -INF
	
	for v: Vector2 in [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]:
		if velocity.dot(v) > best_dot:
			best_dot = velocity.dot(v)
			best = v
	
	var anim: String
	match best:
		Vector2.LEFT:
			anim = "walk_left"
		Vector2.RIGHT:
			anim = "walk_right"
		Vector2.UP:
			anim = "shoot_up"
		Vector2.DOWN:
			anim = "shoot_down"
	
	if $AnimatedSprite2D.animation != anim or not $AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.play(anim)

func animateShooting() -> void:
	
	# We have animations for shooting in the 4 cardinal directions.
	# We need to decide which of those directions to the enemy the player is MOSTLY in.
	
	var playerPos : Vector2 = Player.instance.global_position
	# We get the difference from the player separately on each axis.
	var xposDifference : float = abs(self.global_position.x-playerPos.x)
	var yposDifference : float = abs(self.global_position.y-playerPos.y)
	# We decide which axis the player is farther from. Greater X difference means "mostly horizontal", greater Y difference means "mostly vertical"
	# A second if statement kicks in to decide which of the two directions along the given axis we're dealing in.
	if xposDifference>=yposDifference:
		# HORIZONTAL SHOOTING
		#if i'm to the right of the player, fire to my left. otherwise, to the right
		if self.global_position.x>=playerPos.x:
			enemy_sprite.animation="fire_left"
		else:
			enemy_sprite.animation="fire_right"
	else:
		#VERTICAL SHOOTING
		#if i'm below the player, fire "up" (animation tbd). otherwise, fire down
		if self.global_position.y>=playerPos.y:
			enemy_sprite.animation="fire_up"
		else:
			enemy_sprite.animation="fire_down"
	enemy_sprite.play()
