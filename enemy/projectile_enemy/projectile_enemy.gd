extends Enemy

@export var attack_speed: float = 1.0
@export var attack_range: float = 25
@export_range(0, 90) var attack_spread: float = 0
@export var animation_length: float = 1

func _ready() -> void:
	$ShootProjectileBehavior.attack_speed = attack_speed
	$ShootProjectileBehavior.attack_range = attack_range
	$ShootProjectileBehavior.attack_spread = attack_spread
	$ShootProjectileBehavior.animation_length = animation_length
	
