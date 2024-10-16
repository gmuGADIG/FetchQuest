extends Node2D

@export var max_angular_speed: float ## Exported variable for controlling the max speed of rotation
@export var min_angular_speed: float ## Exported variable for controlling the minimum speed of rotation
@export var sword: ThrownSword       ## Exported variable for the sword that controls the rotation

@onready var speed: float = max_angular_speed ## The current speed of the rotation

func _ready() -> void:
	sword.sword_bounced.connect(change_speed)
	
func change_speed(intensity: float) -> void:
	speed = max(min_angular_speed, intensity * max_angular_speed)
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Rotate the sprite based on the angular speed and the time passed
	rotation += delta * speed
