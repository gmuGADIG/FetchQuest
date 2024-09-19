extends Node

## This array stores
var quests:Array[Object]
var current_quest:Object

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_quest = quests[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	## It checks if there's a quest that's completed
	## If there is, then it removes it
	for quest in quests:
		if quest == null:
			pass
		elif quest.quest_complete == true:
			remove_quest(quest)

## This adds a new quest to the array of quests
func append_quest(quest: Object) -> void:
	quests.append(quest)

## This removes a quest to the array of quests
func remove_quest(quest: Object) -> void:
	if find_quest(quest) != -1:
		quests.remove_at(find_quest(quest))
	else:
		pass

## This finds a quest and return it's index
func find_quest(quest: Object) -> int:
	var index:int
	for q in quests:
		if q.quest_ID == quest.quest_ID:
			return index
		index += 1
	return -1

## This finds a quest and returns the quest itself
func get_quest(quest: Object) -> Object:
	for q in quests:
		if q.quest_ID == quest.quest_ID:
			return q
	return null
