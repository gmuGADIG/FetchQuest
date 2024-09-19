extends Object

## Quest identifier
var quest_ID:int = 0

## If the quest is accepted
var quest_accept:bool = false
## If the quest is complete
var quest_complete:bool = false
## The name of the quest
var quest_name:String = ""
## The quest description
var quest_description:String = ""
## The list of quest instructions
var quest_instructions:Array[String] = [""]
## The current instruction
var current_instruction:String
## The quest client
var quest_client:Object
## The quest rewards
var quest_rewards:Array[Object]

func qppend_instruction(instruction: String) -> void:
	quest_instructions.append(instruction)
	
func set_instruction(index: int) -> void:
	current_instruction = quest_instructions[index]
	
func append_rewards(reward: Object) -> void:
	quest_rewards.append(reward)
