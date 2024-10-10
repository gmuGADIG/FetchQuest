extends Button
var index: int = 1

signal codexButtonPressed(index: int)

func _pressed() -> void:
	codexButtonPressed.emit(index)

func SetIndex(newIndex: int) -> void:
	index = newIndex

func GetIndex() -> int:
	return index
