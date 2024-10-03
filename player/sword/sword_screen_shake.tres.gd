extends Node2D

@export var thrown_sword: ThrownSword
@export var shake_strength: float
@export var shake_duration: float

func _ready() -> void:
	thrown_sword.sword_bounced.connect(_on_sword_bounced)  # Connect the bounce signal to shake the camera

func _on_sword_bounced(intensity: float) -> void:
	MainCam.shake(shake_strength * intensity, shake_duration)
