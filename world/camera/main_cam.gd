class_name MainCam extends Camera2D

static var instance: MainCam

@export var shake_noise: Noise

var _shake_time_left := 0.0
var _shake_strength := 0.0

func _init() -> void:
	instance = self

func _ready() -> void:
	global_position = Player.instance.global_position
	reset_smoothing.call_deferred()

func _process(delta: float) -> void:
	global_position = Player.instance.global_position
	
	_shake_process(delta)

# Should be called every frame. Shakes the camera by changing its [member offset].
func _shake_process(delta: float) -> void:
	if _shake_time_left > 0: # shake
		var t := Time.get_ticks_msec()
		offset = Vector2(shake_noise.get_noise_1d(t), shake_noise.get_noise_1d(-t)) * _shake_strength
		_shake_time_left = move_toward(_shake_time_left, 0, delta / Engine.time_scale)
	else: # no shake
		offset = Vector2(0, 0)
		_shake_strength = 0.0

static func shake(strength: float = 25.0, duration: float = 0.02) -> void:
	# if no MainCam exists, push an error and ignore
	if instance == null:
		push_error("main_cam.gd: screen shake disabled; main camera does not exist")
		return
	
	# ignore shake if a greater shake is currently in effect
	if strength < instance._shake_strength: return
	
	# apply shake
	instance._shake_strength = strength
	instance._shake_time_left = duration
