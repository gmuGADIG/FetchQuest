class_name ThrownSword extends CharacterBody2D

func _process(delta: float) -> void:
	move_and_slide()

func throw(throw_velocity: Vector2) -> void:
	velocity = throw_velocity
