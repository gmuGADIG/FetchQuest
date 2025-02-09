extends NavigationRegion2D

@export var do_updates := true
@export var update_frequency: float = 1.0

var timer := 0.0

func _ready() -> void:
	if not do_updates: process_mode = PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		self.bake_navigation_polygon()
		timer = update_frequency
