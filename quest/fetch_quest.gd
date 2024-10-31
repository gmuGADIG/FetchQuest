class_name FetchQuest extends Quest

var number_of_required:int ## The number of required items to complete the fetch_quest
var item_type:String ## The type of item required to collect

## Checks if the player has the required amount of required items
func quest_progress() -> bool:
	if PlayerInventory.get_quantity(item_type) == number_of_required:
		complete_quest()
		PlayerInventory.remove_quantity(item_type, number_of_required)
		PlayerInventory.items_updated(item_type)
		return true
	else: return false
