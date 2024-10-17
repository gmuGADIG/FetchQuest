extends Button
var index: int = 1

signal codexButtonPressed(index: int)

func _pressed() -> void:
	codexButtonPressed.emit(index)

func set_index(newIndex: int) -> void:
	index = newIndex
