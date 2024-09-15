extends Sprite2D

# Exported variable for controlling the angular speed of rotation
@export var angular_speed: float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Rotate the sprite based on the angular speed and the time passed
	rotation += delta * angular_speed
