extends Button
var index: int = 1

signal codexButtonPressed(index: int)

# Called when the node enters the scene tree for the first time.
func _pressed() -> void:
	codexButtonPressed.emit(index)

func SetIndex(newIndex: int) -> void:
	index = newIndex
