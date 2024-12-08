class_name WaterHeightEnabler extends Node2D

@export var enabled_when_raised := false

static var is_water_raised := false

func _ready() -> void:
	var on := is_water_raised == enabled_when_raised
	self.visible = on
	self.process_mode = PROCESS_MODE_INHERIT if on else PROCESS_MODE_DISABLED
