extends Control

func _update_visibility() -> void:
	visible = PlayerInventory.bomb_unlocked()

func _ready() -> void:
	_update_visibility()

	PlayerInventory.item_updated.connect(func(_key: String) -> void: _update_visibility())
