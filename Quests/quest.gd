class_name Quest extends Resource

## Quest identifier
@export var quest_ID:int = 0

## If the quest is accepted
var quest_accept:bool = false
## If the quest is complete
var quest_complete:bool = false
## If quest is main quest
@export var main_quest:bool = false
## The name of the quest
@export var quest_name:String = ""
## The quest description
@export var quest_description:String = ""
## The list of quest instructions
@export var quest_instructions:Array[String] = [""]
## The current instruction
@export var current_instruction:String
## The quest rewards
##@export var quest_rewards:Array[Object]
## If there's a new quest, then the next quest is run
##@export var next_quest:Object

func accept_quest() -> void:
	quest_accept = true
	quest_complete = false
	
func complete_quest() -> void:
	quest_accept = false
	quest_complete = true

## This function sets the current instruction of the quest
func set_instruction(index: int) -> void:
	current_instruction = quest_instructions[index]
