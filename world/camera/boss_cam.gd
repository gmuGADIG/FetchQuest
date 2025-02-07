extends MainCam

@export var boss: Node2D
@export_range(0, 1) var boss_camera_influence := 0.5

func _process(delta: float) -> void:
	global_position = lerp(Player.instance.global_position, boss.global_position, boss_camera_influence)
	
	_shake_process(delta)
