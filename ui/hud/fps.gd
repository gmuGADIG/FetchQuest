extends Label

func _process(delta: float) -> void:
	text = str(round((1 / delta) * 10) / 10)
