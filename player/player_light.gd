extends PointLight2D

func _ready() -> void:
	visible = Level.instance.player_light_enabled
