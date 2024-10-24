extends Node2D
signal closeToHole
signal inHole

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#Overlaps from Close to Hole
	var closeOverlaps : Array[Node2D] = $closeToHole.get_overlapping_bodies()
	
	# if there are no close overlaps then there are no overlaps period so end 
	if closeOverlaps.size() == 0: return
	var overlaps : Array[Node2D] = $inHole.get_overlapping_bodies()
	
	#check if there are close overlaps but no hole overlaps (aka close but not in hole)
	if overlaps.size() == 0:
		
		# the entity is in a hole
		for body in overlaps:
			if body.is_in_group("HoleOccluder"):
				inHole.emit()
				
		# the entity is close to a hole
		for body in closeOverlaps:
			if body.is_in_group("HoleOccluder"):
				closeToHole.emit() 
	
	pass
