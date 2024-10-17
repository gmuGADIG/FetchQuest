extends NavigationRegion2D

@export var update_frequency: float = 1.0

var timer := 0.0

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		self.bake_navigation_polygon()
		timer = update_frequency
