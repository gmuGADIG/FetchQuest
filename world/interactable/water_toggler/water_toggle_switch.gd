extends Switch

@onready var water_change_label: Label = $CanvasLayer/WaterChangeLabel

func _ready() -> void:
	super._ready()
	
	type = SWITCH_TYPE.Toggle
	activated = WaterHeightEnabler.is_water_raised
	_on_sprite.visible = activated
	_off_sprite.visible = not activated

func activate() -> void:
	super.activate()
	WaterHeightEnabler.is_water_raised = true
	water_change_label.text = "Water Raised!"
	effects()
	
func deactivate() -> void:
	super.deactivate()
	WaterHeightEnabler.is_water_raised = false
	water_change_label.text = "Water Lowered!"
	effects()
	
func effects() -> void:
	create_tween().tween_method(MainCam.shake, 0.0, 25.0, 2.0)
	
	water_change_label.position.y = -90
	water_change_label.modulate.a = 0
	create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).tween_property(water_change_label, "position:y", 0, 1.5)
	create_tween().tween_property(water_change_label, "modulate:a", 1.0, 2.0)
	create_tween().tween_property(water_change_label, "modulate:a", 0.0, 1.0).set_delay(2.5)
