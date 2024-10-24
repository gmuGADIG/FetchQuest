extends Node
@onready var node_to_load: String = "NONE"

func set_point(point_name: String) -> void:
	node_to_load = point_name
