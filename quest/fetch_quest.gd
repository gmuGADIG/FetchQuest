class_name FetchQuest extends Quest

var number_of_required:Array[int] ## The number of required items to complete the fetch_quest
var item_types:Array[String] ## The type of item required to collect

func _items_collected(index: int) -> bool:
	return PlayerInventory.get_quantity(item_types[index]) >= number_of_required[index]

func _on_item_updated() -> void:
	var check: bool = true
	for i in range(len(number_of_required)):
		if !(_items_collected(i)):
			check = false
	if check == true:
		state = State.COMPLETED
		PlayerInventory.item_updated.disconnect(_on_item_updated)
		QuestSystem.quest_completed.emit(self)

func turn_in() -> void:
	super.turn_in()
	for i in range(len(number_of_required)):
		PlayerInventory.remove_quantity(item_types[i], number_of_required[i])

func _assign_hook() -> void:
	PlayerInventory.item_updated.connect(_on_item_updated)
	_on_item_updated()
