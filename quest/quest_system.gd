extends Node

## Emitted when the quest is assigned by an NPC.
signal quest_assigned(quest: Quest)
## Emitted when the quest is completed by the player and needs to be turned in.
signal quest_completed(quest: Quest)

## This list contains every quest the player can obtain.
@export var quests:Array[Quest]

## Assigns a quest to the player
func assign_quest(id: String) -> void:
	_find_quest_by_id(id).assign_quest()

func get_assigned_quests() -> Array[Quest]:
	return quests.filter(func(q: Quest) -> bool: return q.is_assigned())

func get_completed_quests() -> Array[Quest]:
	return quests.filter(func(q: Quest) -> bool: return q.is_completed())

func get_turned_in_quests() -> Array[Quest]:
	return quests.filter(func(q: Quest) -> bool: return q.is_turned_in())

func _find_quest_by_id(id: String) -> Quest:
	for q in quests:
		if q.quest_id == id:
			return q
	
	assert(false, "Could not find quest of id '%s'" % id)
	return null
