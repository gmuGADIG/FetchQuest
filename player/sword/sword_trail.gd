extends Line2D

# Exported variable to control the size of the trail (number of points)
@export var trail_size: int
var queue: Array = []  # Queue to store positions for the trail

# Called every frame to update the trail
func _process(_delta: float) -> void:
	# Add the current position of the parent node to the front of the queue
	queue.push_front(get_parent().position)
	
	# If the queue exceeds the defined trail size, remove the oldest point
	if queue.size() > trail_size:
		queue.pop_back()
	
	# Clear the previous trail points to avoid duplications
	clear_points()
	
	# Add each point in the queue to the Line2D
	for point: Vector2 in queue:
		add_point(point)
