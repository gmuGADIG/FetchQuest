extends Area2D

@export var entry_point: String

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and Player.instance in get_overlapping_bodies():
		var scene_name := get_tree().current_scene.scene_file_path.trim_suffix(".remap").trim_suffix(".tscn").get_file()
		FastTravelPoints.add_to_travel_points(TravelPoint.new(scene_name, entry_point))
		add_sibling(preload("res://ui/fast_travel_map/fast_travel_map.tscn").instantiate())
