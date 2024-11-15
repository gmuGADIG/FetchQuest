@tool
class_name TreeGen extends StaticBody2D
## Randomly scatters trees across a polygon.
## This node must have a child of type and name "CollisionPolygon2D" to work.

var rng: RandomNumberGenerator

@export var refresh: bool:
	set(value):
		generate_trees()

@export var seed: int:
	set(value):
		seed = value
		generate_trees()

## This scene is repeatedly instantiated across the polygon.
@export var tree_scene: PackedScene:
	set(value):
		tree_scene = value
		generate_trees()

## If [member secondary_tree_odds] is not zero, this scene will sometimes be instantiated instead.
## Otherwise, this property has no effect and can be null.
@export var secondary_tree_scene: PackedScene:
	set(value):
		secondary_tree_scene = value
		generate_trees()

## Odds of generating a secondary tree. e.g. if this value is 0.5, half of the trees will be the secondary tree.
@export_range(0, 1) var secondary_tree_odds := 0.0:
	set(value):
		secondary_tree_odds = value
		generate_trees()

## Determines how much space is between each tree. Higher values means sparser trees.
@export_range(50, 500) var tree_interval := 150.0:
	set(value):
		tree_interval = value
		generate_trees()

## How much to randomize each tree's position. A value of 0 means the trees generate in a perfect grid.
@export_range(0, 1) var randomness := 0.3:
	set(value):
		randomness = value
		generate_trees()

func _ready() -> void:
	generate_trees()

func clear_trees() -> void:
	var old_trees := get_node_or_null("Trees")
	if old_trees != null:
		old_trees.free()

func generate_trees() -> void:
	if not is_inside_tree(): return
	
	y_sort_enabled = true
	
	rng = RandomNumberGenerator.new()
	rng.seed = seed
	
	var collision_poly: CollisionPolygon2D = $CollisionPolygon2D
	
	assert(tree_scene != null, "TreeGen at '%s' has no tree scene configured." % get_parent().name)
	assert(collision_poly != null, "TreeGen at '%s' must have a child named 'CollisionPolygon2D'." % get_parent().name)
	assert(secondary_tree_scene != null or secondary_tree_odds == 0, "TreeGen at '%s' has no secondary tree, but the secondary tree odds are not zero." % get_path())
	
	clear_trees()
	
	var rect := get_polygon_rect(collision_poly.polygon)
	var possible_points := get_points_in_rect(rect)
	var valid_points := possible_points.filter(Geometry2D.is_point_in_polygon.bind(collision_poly.polygon))
	
	#print("rect = ", rect)
	#print("possible_points = ", possible_points)
	#print("valid_points = ", valid_points)
	
	for point: Vector2 in valid_points:
		#print("spawning at ", point)
		spawn_tree(point)
	
func spawn_tree(point: Vector2) -> void:
	var tree_holder := get_node_or_null("Trees")
	if tree_holder == null:
		tree_holder = Node2D.new()
		tree_holder.name = "Trees"
		tree_holder.y_sort_enabled = true
		add_child(tree_holder)
	
	var tree := get_tree_scene().instantiate()
	tree.position = point
	tree_holder.add_child(tree)

func get_tree_scene() -> PackedScene:
	if rng.randf() < secondary_tree_odds:
		return secondary_tree_scene
	else:
		return tree_scene

func get_polygon_rect(polygon: PackedVector2Array) -> Rect2:
	var shape := ConvexPolygonShape2D.new()
	shape.set_point_cloud(polygon)
	return shape.get_rect()

func get_points_in_rect(rect: Rect2) -> Array[Vector2]:
	var points: Array[Vector2] = []
	
	var x_count := rect.size.x / tree_interval
	var y_count := rect.size.y / tree_interval
	
	var rand_offset := randomness * tree_interval
	
	for x in range(x_count+1):
		for y in range(y_count+1):
			var point := rect.position + Vector2(x * tree_interval, y * tree_interval)
			point += Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)) * rand_offset
			points.append(point)
	
	return points
