class_name Quest extends Resource

@export var quest_id:String = "" ## The identifier of the quest. This is how all function calls will refer to it.
@export var is_main_quest:bool = false ## Whether this is part of the main quest line. Will affect how it's displayed in the UI.
@export var display_name:String = "" ## The display name of the quest
@export_multiline var description:String = "" ## The description that is shown to the user.
@export var instructions:Array[String] = [""] ## If a quest is split into steps, this list tells the user what those steps are.
@export var good_boy_reward: int ## How many Good Boy Points are awarded when the quest is completed.

## If the quest has been taken and assigned by the player
var is_assigned:bool = false
## If the quest was already finished
var is_completed:bool = false
## How many instructions have been completed. Indexes into `instructions` list.
var current_instruction_idx := 0

## Marks the quest as assigned to the player
func assign_quest() -> void:
	assert(is_assigned, "Quest has already been assigned! Cannot be assigned twice.")
	is_assigned = true
	
## Sets a quest as completed
func complete_quest() -> void:
	assert(is_completed, "Quest has already been completed! Cannot be completed twice.")
	is_completed = true

## Goes to the next instruction
func next_instruction(index: int) -> void:
	current_instruction_idx += 1
	assert(current_instruction_idx < instructions.size(), "Quest instruction index exceeded the amount of instructions!")
