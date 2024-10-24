extends Node

## This is the save path
#var save_path = "user:"

## This array stores the list of quests
@export var quests_list:Array[Quest]
@export var current_quests:Array[Quest]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for quest in current_quests:
		if quest.quest_complete == true:
			remove_quest(quest)

## This adds a new quest to the array of quests
func append_quest(id: String) -> void:
	var quest:Quest = find_quest_by_id(id)
	if (quest != null): current_quests.append(quest)

## This removes a quest to the array of quests
func remove_quest(quest: Quest) -> void:
	if find_quest_index(quest) != -1:
		current_quests.remove_at(find_quest_index(quest))
	else:
		pass

## This finds a quest and return it's index
func find_quest_index(quest: Quest) -> int:
	var index:int
	for q in current_quests:
		if q.quest_ID == quest.quest_ID:
			return index
		index += 1
	return -1
	
func find_quest_by_id(id: String) -> Quest:
	for q in quests_list:
		if q.quest_ID == id:
			return q
	return null

## The saving function will be implemented later
func saving_quests() -> void:
	pass
