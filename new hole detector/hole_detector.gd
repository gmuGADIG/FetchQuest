extends Node2D
signal closeToHole
signal onPlatform
signal offPlatform
signal inHole

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_close_to_hole_body_entered(body: Node2D) -> void:
	print("body entered")
	if body.is_in_group("HoleOccluder"): 
		onPlatform.emit()
	elif body.is_in_group("Hole"):
		closeToHole.emit()
		print("body is hole")		
	pass # Replace with function body.


func _on_in_hole_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hole"):
		inHole.emit()
		print("fell in hole")
	pass # Replace with function body.


func _on_in_hole_body_exited(body: Node2D) -> void:
	if body.is_in_group("HoleOccluder"): 
		offPlatform.emit()
		
	pass # Replace with function body.
