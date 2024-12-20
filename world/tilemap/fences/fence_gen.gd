@tool
class_name FenceGen extends Line2D
## Randomly scatters trees across a polygon.
## This node must have a child of type and name "CollisionPolygon2D" to work.

var rng: RandomNumberGenerator

@export var refresh: bool:
	set(value):
		generate_fences()

@export var seed: int:
	set(value):
		seed = value
		generate_fences()

## This scene is repeatedly instantiated across the polygon.
@export var fence_scene: PackedScene
## If [member secondary_fence_odds] is not zero, this scene will sometimes be instantiated instead.
## Otherwise, this property has no effect and can be null.
@export var secondary_fence_scene: PackedScene

## Odds of generating a secondary fence. e.g. if this value is 0.5, half of the fences will be the secondary fence.
@export_range(0, 1) var secondary_fence_odds := 0.0

## Determines how much space is between each fence. Higher values means sparser fences.
@export_range(0, 500) var fence_spacing := 50.0

## How much to randomize each fence's position. A value of 0 means the fences generate in a perfect line with equal spacing.
#@export_range(0, 1) var randomness := 0.3

func _ready() -> void:
	generate_fences()

func clear_fences() -> void:
	var old_fences := get_node_or_null("Fences")
	if old_fences != null:
		old_fences.free()

func generate_fences() -> void:
	rng = RandomNumberGenerator.new()
	rng.seed = seed
	
	
	
	assert(y_sort_enabled, "FenceGen at '%s' must have y-sort enabled." % get_parent().name)
	assert(fence_scene != null, "FenceGen at '%s' has no fence scene configured." % get_parent().name)
	assert(secondary_fence_scene != null or secondary_fence_odds == 0, "FenceGen at '%s' has no secondary fence, but the secondary fence odds are not zero." % get_path())
	
	clear_fences()
	
	var fence_points := get_points_in_line()
	
	#print("rect = ", rect)
	#print("possible_points = ", possible_points)
	#print("valid_points = ", valid_points)
	
	for fence_point: Vector2 in fence_points:
		#print("spawning at ", point)
		spawn_fence(fence_point)
	
func spawn_fence(point: Vector2) -> void:
	var fence_holder := get_node_or_null("Fences")
	if fence_holder == null:
		fence_holder = Node2D.new()
		fence_holder.name = "Fences"
		fence_holder.y_sort_enabled = true
		add_child(fence_holder)
	
	var fence := get_fence_scene().instantiate()
	fence.position = point
	fence_holder.add_child(fence)

func get_fence_scene() -> PackedScene:
	if rng.randf() < secondary_fence_odds:
		return secondary_fence_scene
	else:
		return fence_scene

func get_points_in_line() -> Array[Vector2]:
	
	
	##The locations where fences will be instantiated. Will be returned
	var fence_points: Array[Vector2] = []
	
	if(points.size() == 0):
		return []
		
	##iterates over the positions in space to calculate fence points
	var current_location : Vector2 = points[0]
	
	##The point that the current_location is iterating towards
	var travel_to_index : int = 1
	
	var done : bool  = false
	while(travel_to_index<points.size()):
		fence_points.append(current_location)
		var distance_until_next_point : float = current_location.distance_to(points[travel_to_index])
		#var next_location : Vector2
		if(distance_until_next_point>fence_spacing):#
			current_location = current_location.move_toward(points[travel_to_index],fence_spacing)
		else:#Edge case for when going around a bend
			#Change which point is being traced
			travel_to_index+=1
			#Terminating case
			if travel_to_index>=points.size():
				break
					
			var remaining_distance : float = fence_spacing-distance_until_next_point
			
			current_location = points[travel_to_index-1].move_toward(points[travel_to_index],remaining_distance)
			
		
		
			
	return fence_points
