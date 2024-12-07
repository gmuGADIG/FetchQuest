class_name FetchQuest extends Quest

var number_of_required:int ## The number of required items to complete the fetch_quest
var item_type:String ## The type of item required to collect

func _items_collected() -> bool:
	return PlayerInventory.get_quantity(item_type) >= number_of_required

func _on_item_updated(key: String) -> void:
	if key == item_type:
		if _items_collected():
			state = State.COMPLETED
			PlayerInventory.item_updated.disconnect(_on_item_updated)
			QuestSystem.quest_completed.emit(self)

func turn_in() -> void:
	super.turn_in()
	PlayerInventory.remove_quantity(item_type, number_of_required)

func _assign_hook() -> void:
	PlayerInventory.item_updated.connect(_on_item_updated)
	_on_item_updated(item_type)
