class_name TravelPoint extends RefCounted

var scene_name: String
var entry_point_name: String

func _init(scene: String, entry_point: String) -> void:
	scene_name = scene
	entry_point_name = entry_point

func equals(other: TravelPoint) -> bool:
	return (scene_name == other.scene_name) and (entry_point_name == other.entry_point_name)
