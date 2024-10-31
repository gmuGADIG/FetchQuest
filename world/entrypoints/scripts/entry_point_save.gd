extends Node
#Written by Samuel Parker (github: samrparker, discord: @samrparker12), contact me if there are any issues!
@onready var node_to_load: String = "NONE"

#Sets the name of the node to move to in the next scene
func set_point(point_name: String) -> void:
	node_to_load = point_name
