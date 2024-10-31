extends Node2D
#Written by Samuel Parker (github: samrparker, discord: @samrparker12), contact me if there are any issues!
	
#When ready is called, the player must have entered a new scene. This sets the players' position to the position of the node,
#but also adds some debug messages if something goes wrong (if the node was not found or the player wasn't found)
func _ready() -> void:
	var nodeToEnter: Node2D = get_node(EntryPointSave.node_to_load)
	
	if(EntryPointSave.node_to_load != "NONE" and %Player != null and nodeToEnter != null):
		%Player.position = nodeToEnter.position
		
	#Will probably want to remove this once the game is done, but this just gives a little info as to why this likely didnt work
	if(%Player == null):
		print("Player node is null! Ensure there is a player node to set the position of!")
	if(nodeToEnter == null):
		print("The node the player was supposed to be set to (the entry point node) is null! Either A: The node you set is not in the scene, or B: there is some other issue (programming)")
		
func _process(delta: float) -> void:
	pass
