extends Node2D

static var projectile :PackedScene = preload("res://enemy/projectile_enemy/projectile/projectile.tscn")
#Attack speed (time between shots)
@export var attack_speed : float = 1.0

#How close the enemy must be to start shooting.
@export var attack_range : float = 25.0

#Accuracy
@export_range(0, 90) var attack_spread : float = 0

#Shoot animation length
@export var animation_length : float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(projectile != null)
	$Timer.wait_time = attack_speed

		
func shoot() -> void:
	var proj : Node2D = projectile.instantiate()
	proj.global_position = self.global_position
	proj.global_rotation_degrees = add_spread(self.global_rotation_degrees, attack_spread)
	get_parent().add_sibling(proj)

func add_spread(rot: float, spread: float) -> float:
	var rand_factor :float = randf()*spread *2 - spread
	return rot + rand_factor
