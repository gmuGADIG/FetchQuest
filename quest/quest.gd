class_name Quest extends Resource

@export var quest_id:String = "" ## The identifier of the quest. This is how all function calls will refer to it.
@export var is_main_quest:bool = false ## Whether this is part of the main quest line. Will affect how it's displayed in the UI.
@export var display_name:String = "" ## The display name of the quest
@export_multiline var description:String = "" ## The description that is shown to the user.
@export var instructions:Array[String] = [""] ## If a quest is split into steps, this list tells the user what those steps are.
@export var good_boy_reward: int ## How many Good Boy Points are awarded when the quest is completed.

## How many instructions have been completed. Indexes into `instructions` list.
var current_instruction_idx := 0

enum State {
	## Quest exists in the world, but the player doesn't know about it.
	UNASSIGNED,
	## Player has been told about the quest, but the player hasn't finished it.
	ASSIGNED,
	## Player has finished the quest
	COMPLETED,
	## Player has turned in the quest
	TURNED_IN
}

var state := State.UNASSIGNED

func is_unassigned() -> bool:
	return state == State.UNASSIGNED
func is_assigned() -> bool:
	return state == State.ASSIGNED
func is_completed() -> bool:
	return state == State.COMPLETED
func is_turned_in() -> bool:
	return state == State.TURNED_IN

## Called when the quest is assigned and by the save system.
## Assume this may be called any number of times.
func _assign_hook() -> void:
	pass

## Marks the quest as assigned to the player
func assign_quest() -> void:
	assert(is_unassigned(), "Quest has already been assigned! Cannot be assigned twice.")
	_assign_hook()
	state = State.ASSIGNED
	QuestSystem.quest_assigned.emit(self)
	
## Mark quest as turned in
func turn_in() -> void:
	assert(is_completed(), "Quest needs to be completed before being turned in!")
	state = State.TURNED_IN
	PlayerInventory.good_boy_points += good_boy_reward

## Goes to the next instruction
func next_instruction() -> void:
	current_instruction_idx += 1
	assert(current_instruction_idx < instructions.size(), "Quest instruction index exceeded the amount of instructions!")
