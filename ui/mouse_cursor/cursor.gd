extends Node2D
class_name Cursor

@export var cursor_distance: int = 300
@export var before_fade_ms: int = 1000
@export var fade_time_ms: int = 1000

static var instance : Cursor;

var last_aim_time : int
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	instance = self


#Sets the cursor mode to controller, hides the actual cursor and replaces it with a sprite
func controller_mode() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$ControllerCursorSprite.visible = true
	pass

#Sets the cursor mode to mouse, hides the fake cursor sprite and shows the real cursor
func mouse_mode() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$ControllerCursorSprite.visible = false
	pass

#Is called when the aim direction is being modified.
func changed_aim() -> void:
	last_aim_time = Time.get_ticks_msec()
	
# 
func _process(delta: float) -> void:
	if(ControllerManager.is_controller):
		$ControllerCursorSprite.position = ControllerManager.get_joystick_aim()*cursor_distance
		#Decide the transparency of the cursor
		
		var time_passed : int = Time.get_ticks_msec() - last_aim_time
		if time_passed < before_fade_ms:
			$ControllerCursorSprite.modulate.a = 1
		elif time_passed < before_fade_ms + fade_time_ms:
			var fade_percent : float = 1-(float)(time_passed-before_fade_ms)/fade_time_ms
			$ControllerCursorSprite.modulate.a = fade_percent
		else:
			$ControllerCursorSprite.modulate.a = 0
	pass
