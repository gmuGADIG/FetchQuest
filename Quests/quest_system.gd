extends Node

## This array stores
@export var quests_list:Array[Quest]
@export var current_quest:Array[Quest]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	## It checks if there's a quest that's completed
	## If there is, then it removes it
	for quest in quests_list:
		if quest == null:
			pass
		elif quest.quest_complete == true:
			remove_quest(quest)

## This adds a new quest to the array of quests
func append_quest(quest: Quest) -> void:
	quests_list.append(quest)

## This removes a quest to the array of quests
func remove_quest(quest: Quest) -> void:
	if find_quest_index(quest) != -1:
		quests_list.remove_at(find_quest_index(quest))
	else:
		pass

## This finds a quest and return it's index
func find_quest_index(quest: Quest) -> int:
	var index:int
	for q in quests_list:
		if q.quest_ID == quest.quest_ID:
			return index
		index += 1
	return -1
