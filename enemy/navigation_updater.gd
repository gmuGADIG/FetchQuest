extends NavigationRegion2D

func _process(delta: float) -> void:
	self.bake_navigation_polygon()
