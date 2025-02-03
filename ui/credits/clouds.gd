extends TextureRect

const speed := 50.0

func _process(delta: float) -> void:
	position.x += speed * delta
	if position.x * sign(speed) > 1152:
		position.x -= 1152 * 2 * sign(speed)
