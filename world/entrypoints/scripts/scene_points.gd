extends Node2D
#var players: = get_tree().get_nodes_in_group("Player")
	
func _ready() -> void:
	if(EntryPointSave.node_to_load != "NONE"):
		%Player.transform = get_node(EntryPointSave.node_to_load).transform
