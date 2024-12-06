extends HSlider

@export var audio_bus_name := "Master"

@onready var _bus := AudioServer.get_bus_index(audio_bus_name)

func _ready() -> void:
	value_changed.connect(_on_value_changed)
	# Make sure we have a range of 0-1 for linear_to_db() in _on_value_changed().
	min_value = 0
	max_value = 1
	# Make our step something nice and small for small increments in volume.
	# However, this also affects the gamepad control, so make sure the increment
	# is big enough for gamepad control.
	step = 0.01
	value = db_to_linear(AudioServer.get_bus_volume_db((_bus)))

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus, linear_to_db(value))
