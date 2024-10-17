extends Node
#all unlocked points
@export var unlocked_fast_travel_points : Array[String] 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#adds new points but won't save duplicates
func add_to_travel_points(location: String) -> void:
	var inList := false
	for locations in unlocked_fast_travel_points:
		if(location == locations && !inList):
			inList = true
	if(!inList):
		unlocked_fast_travel_points.append(location)
		print(location + " added to travel points")
	
#see if point is unlocked to see if it should be shown on map
func point_unlocked(travel_point: String) -> bool:
	for locations in unlocked_fast_travel_points:
		if(travel_point == locations):
			return true
	return false
	
