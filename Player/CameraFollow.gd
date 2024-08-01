extends Node2D
##How far the camera will extend
@export var view_distance: float = 100.0

##How far the mouse needs to be be from the player to move the camera from the center.
##Has no effect on Controller Mode camera.
@export_range(0, 1, 0.05) var mouse_distance_threshold: float = 0.75

func _process(delta):
	#Sets own position at a 
	if ControllerManager.isControllerMode():
		position = Input.get_vector("look_left", "look_right", "look_up", "look_down") * view_distance
		return
	elif ControllerManager.isKeyboardMode():
		var diff_vector: Vector2 = get_global_mouse_position() - get_parent().global_position
		var dist_offset: float = clamp(diff_vector.length()/view_distance, 0, 1)
		if dist_offset < mouse_distance_threshold:
			dist_offset = 0
		position = diff_vector.normalized() * view_distance * dist_offset
