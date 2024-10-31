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
	#if overlaps.size() == 0:
		
		# the entity is in a hole
		#for body in overlaps:
		#	if body.is_in_group("Hole"):
		#		inHole.emit()
		#		print("fell in hole")
		# the entity is close to a hole
		#for body in closeOverlaps:
		#	if body.is_in_group("Hole"):
		#		closeToHole.emit() 
	
	pass


func _on_close_to_hole_body_entered(body: Node2D) -> void:
	print("body entered")
	if body.is_in_group("Hole"):
		closeToHole.emit()
		print("body is hole")		
	pass # Replace with function body.


func _on_in_hole_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hole"):
		inHole.emit()
		print("fell in hole")
	pass # Replace with function body.
