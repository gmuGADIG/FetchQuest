extends CanvasLayer
class_name FastTravelMap

func _ready() -> void:
	get_tree().paused = true;
	#$Buttons/Locations/Resume.grab_focus()

func _on_tree_exit() -> void:
	get_tree().paused = false;
	
func entered_at(travel_point : TravelPoint) -> void:
	for button : ToiletTravelIcon in $Buttons/Locations.get_children():
		if button.scene_name == travel_point.scene_name && button.entry_point == travel_point.entry_point_name:
			button.grab_focus()
			#print("grabbed focus")

func _on_resume_pressed() -> void:
	get_tree().paused = false;
	queue_free();
