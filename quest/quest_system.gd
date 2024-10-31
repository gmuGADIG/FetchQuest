extends Node

## This list contains every quest the player can obtain.
@export var quests:Array[Quest]

## Assigns a quest to the player
func assign_quest(id: String) -> void:
	_find_quest_by_id(id).assign_quest()

## Finishes a quest
func complete_quest(id: String) -> void:
	_find_quest_by_id(id).complete_quest()

# TODO: func get_assigned_quests() -> Array[Quest]
# TODO: func get_completed_quests() -> Array[Quest]

func _find_quest_by_id(id: String) -> Quest:
	for q in quests:
		if q.quest_id == id:
			return q
	
	assert(false, "Could not find quest of id '%s'" % id)
	return null
