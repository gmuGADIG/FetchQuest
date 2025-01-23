class_name FetchQuest extends Quest

@export var fetch_items: Array[FetchItem] ## The type of item required to collect

func _items_collected() -> bool:
	for item in fetch_items:
		if PlayerInventory.get_quantity(item.id) < item.count:
			return false
	return true

func _on_item_updated(_key: String) -> void:
	if _items_collected():
		state = State.COMPLETED
		PlayerInventory.item_updated.disconnect(_on_item_updated)
		QuestSystem.quest_completed.emit(self)

func turn_in() -> void:
	super.turn_in()
	for item in fetch_items:
		PlayerInventory.remove_quantity(item.id, item.count)

func _assign_hook() -> void:
	PlayerInventory.item_updated.connect(_on_item_updated)
	_on_item_updated("bababooey")
