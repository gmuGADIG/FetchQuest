extends Node

## This list contains every quest the player can obtain.
@export var quests:Array[Quest]

## Assigns a quest to the player
func assign_quest(id: String) -> void:
	_find_quest_by_id(id).assign_quest()

## Finishes a quest
func complete_quest(id: String) -> void:
	_find_quest_by_id(id).complete_quest()

func get_assigned_quests() -> Array[Quest]:
	var array:Array[Quest]
	for quest in quests:
		if quest.is_assigned:
			array.append(quest)
	return array

func get_completed_quests() -> Array[Quest]:
	var array:Array[Quest]
	for quest in quests:
		if quest.is_completed:
			array.append(quest)
	return array

func _find_quest_by_id(id: String) -> Quest:
	for q in quests:
		if q.quest_id == id:
			return q
	
	assert(false, "Could not find quest of id '%s'" % id)
	return null
