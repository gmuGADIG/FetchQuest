extends Node
#all unlocked points
var unlocked_fast_travel_points : Array[TravelPoint] 

#adds new points but won't save duplicates
func add_to_travel_points(new_location: TravelPoint) -> void:
	if point_unlocked(new_location): return
	
	unlocked_fast_travel_points.append(new_location)
	print("location '%s:%s' added to travel points" % [new_location.scene_name, new_location.entry_point_name])

#see if point is unlocked to see if it should be shown on map
func point_unlocked(travel_point: TravelPoint) -> bool:
	for point in unlocked_fast_travel_points:
		if point.equals(travel_point): return true
	return false
