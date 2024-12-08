extends Switch

func _ready() -> void:
	super._ready()
	
	type = SWITCH_TYPE.Toggle
	activated = WaterHeightEnabler.is_water_raised
	_on_sprite.visible = activated
	_off_sprite.visible = not activated

func activate() -> void:
	super.activate()
	WaterHeightEnabler.is_water_raised = true
	print("Water toggled ON")
	
func deactivate() -> void:
	super.deactivate()
	WaterHeightEnabler.is_water_raised = false
	print("Water toggled OFF")
	
