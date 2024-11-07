class_name RescueQuest extends Quest

## Things to add: When the player talks to an npc, make sure to access the quest system, see if there is a Rescue Quest
## with the same name as the NPC, and if the curren scene's name is the same as that quests' scene_name parameter, call that 
## quests' turn in function

var npc_name: String ## The name of the npc the player needs to talk to to complete the quest
var scene_name: String ## The name of the level/dungeon/scene the npc will be in, could be used for if the same NPC will be in multiple dungeons in the same quest

func turn_in() -> void:
	super.turn_in()
