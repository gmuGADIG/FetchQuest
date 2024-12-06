extends Node2D

static var projectile :PackedScene = preload("res://enemy/projectile_enemy/projectile/projectile.tscn")
#Attack speed (time between shots)
@export var attack_speed : float = 1.0

#How close the enemy must be to start shooting.
@export var attack_range : float = 2.0

#Accuracy
@export_range(0, 90) var attack_spread : float = 0

#Shoot animation length
@export var animation_length : float = 1

@export var sprite : AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(projectile != null)
	$CooldownTimer.wait_time = attack_speed
	$AttackRange/CollisionShape2D.scale *= attack_range
	
	

func _enter_tree() -> void:
	# apparently, taking a timer out of and back into a tree breaks it, since autostart is disabled after entering the tree
	# since enemies are unloaded and reloaded by taking them out of the tree, we need to work around this
	$CooldownTimer.start.call_deferred()

func timeout() -> void:
	for body: Node2D in $"AttackRange".get_overlapping_bodies():
		if body is Player:
			shoot()

func shoot() -> void:
	var proj : Node2D = projectile.instantiate()
	proj.global_position = self.global_position
	# Finds the player and rotates the bullet to be pointing towards their position
	proj.look_at(get_tree().get_first_node_in_group("Player").position)
	# Adds some spread
	proj.global_rotation_degrees += randf()*attack_spread *2 - attack_spread
	get_parent().add_sibling(proj)
	
	animateShooting()

func animateShooting() -> void:
	
	# We have animations for shooting in the 4 cardinal directions.
	# We need to decide which of those directions to the enemy the player is MOSTLY in.
	
	var playerPos : Vector2 = get_tree().get_first_node_in_group("Player").global_position
	# We get the difference from the player separately on each axis.
	var xposDifference : float = abs(self.global_position.x-playerPos.x)
	var yposDifference : float = abs(self.global_position.y-playerPos.y)
	# We decide which axis the player is farther from. Greater X difference means "mostly horizontal", greater Y difference means "mostly vertical"
	# A second if statement kicks in to decide which of the two directions along the given axis we're dealing in.
	if xposDifference>=yposDifference:
		# HORIZONTAL SHOOTING
		#if i'm to the right of the player, fire to my left. otherwise, to the right
		if self.global_position.x>=playerPos.x:
			sprite.animation="fire_left"
		else:
			sprite.animation="fire_right"
	else:
		#VERTICAL SHOOTING
		#if i'm below the player, fire "up" (animation tbd). otherwise, fire down
		if self.global_position.y>=playerPos.y:
			sprite.animation="fire_right"
		else:
			sprite.animation="fire_down"
	sprite.play()
