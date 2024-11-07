extends Node

# implementation of the algorithm described in this paper
# https://royalsocietypublishing.org/doi/10.1098/rsif.2014.0719#RSIF20140719F1

var shepherd: Node2D
var doConsiderSword: bool
# number of sheep in the simulation
var n: int
var sheep_safety_states: Array[bool] = []
@export var shepherd_sight_distance: float = 100.0
@export var personal_space_distance: float = 40.0
@export var sheep: Array[Animal] = []
@export var nNeighbors: int = 2
@export var sheep_speed: float = 5.0

@export var DEBUG_shepherd: Node2D = null

var p_sub_a: float = 2.0
var p_sub_s: float = 1.0
var c: float = 1.05
var h: float = 0.5
var wander_speed: float = 20.0
var inertia_vectors: Array[Vector2] = []
var drags: Array[float] = []
var wander_vectors: Array[Vector2] = []
var wander_strengths: Array[float] = []

# calculate and set the best shepherd for the given sheep
func determine_shepherd(to: int) -> void:
	shepherd = DEBUG_shepherd

func getNClosestNeighbors(to: int) -> Array[int]:
	var out: Array[int] = []
	var exclude: Array[int] = [to]
	# note: this is slow.
	for i in range(0, nNeighbors):
		var closestDistance: float = INF
		var closestSheep: int = -1
		for s in range(0, n):
			if (s in exclude):
				continue
			var curr_distance: float = sheep[to].global_position.distance_to(sheep[s].global_position)
			if curr_distance < closestDistance:
				closestDistance = curr_distance
				closestSheep = s
		out.append(closestSheep)
		exclude.append(closestSheep)
	
	return out

func calcNeighborLCM(of: int) -> Vector2:
	var neighbors: Array[int] = getNClosestNeighbors(of)
	var out: Vector2 = Vector2.ZERO
	var positions: Array[Vector2] = []
	for i in range(0, nNeighbors):
		out.x += sheep[neighbors[i]].global_position.x
		out.y += sheep[neighbors[i]].global_position.y
	
	out.x /= nNeighbors
	out.y /= nNeighbors
	
	return out

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	n = sheep.size()
	inertia_vectors.resize(n)
	drags.resize(n)
	wander_strengths.resize(n)
	wander_vectors.resize(n)
	sheep_safety_states.resize(n)
	
	for i in range(0, n):
		sheep_safety_states[i] = false
		inertia_vectors[i] = Vector2.ZERO
		drags[i] = 0.001
		wander_vectors[i] = Vector2.from_angle(randf() * 2.0 * PI)
		wander_strengths[i] = randf()

func get_shepherd_distance(s: int) -> float:
	return shepherd.global_position.distance_to(sheep[s].global_position)

func get_too_close_neighbors(to: int) -> Array[int]:
	var out: Array[int] = []
	for s in range(0, n):
		if s == to:
			continue
		var curr_distance: float = sheep[to].global_position.distance_to(sheep[s].global_position)
		if curr_distance <= personal_space_distance:
			out.append(s)
	
	return out

func calc_personal_space(to: int) -> Vector2:
	var out: Vector2 = Vector2.ZERO
	var too_close_neighbors: Array[int] = get_too_close_neighbors(to)
	
	for s in too_close_neighbors:
		var sheep_difference_vector: Vector2 = (sheep[to].global_position - sheep[s].global_position)
		var weight: float = (1.0 / sheep_difference_vector.length())
		out += sheep_difference_vector * weight
	
	return out.normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	for s in range(0, n):
		# do we see the shepherd?
		determine_shepherd(s)
		
		# shepherd circle
		sheep[s].shepherd_circle_radius = shepherd_sight_distance
		sheep[s].personal_circle_radius = personal_space_distance
		sheep[s].shepherd_position = Vector2.ZERO
		
		var shepherd_distance: float = get_shepherd_distance(s)
		var shepherd_avoidance_vector: Vector2 = Vector2.ZERO
		var herding_vector: Vector2 = Vector2.ZERO
		var not_running: bool = shepherd_distance > shepherd_sight_distance
		if shepherd_distance <= shepherd_sight_distance:
			sheep[s].shepherd_position = shepherd.global_position
			# we see the shepherd, get an avoidance vector
			shepherd_avoidance_vector = (sheep[s].global_position - shepherd.global_position).normalized()
			
			
			sheep[s].draw_avoidance_vector(shepherd_avoidance_vector * 200.0)
			sheep[s].draw_shepherd_vector(shepherd.global_position)
			
			# also, since we see the scary shepherd, herd together for safety
			herding_vector = sheep[s].to_local(calcNeighborLCM(s))
			sheep[s].draw_herding_info(calcNeighborLCM(s), herding_vector)
		# we want each sheep to maintain a personal space bubble
		var personal_space_vector: Vector2 = calc_personal_space(s)
		
		if (randf() > 0.98):
			wander_vectors[s] = Vector2.from_angle(randf() * PI * 2.0)
			wander_strengths[s] = randf()
		
		var sheep_heading: Vector2 = (
			(h * drags[s] * inertia_vectors[s].normalized()) +
			(c * drags[s] * herding_vector.normalized()) +
			(p_sub_a * personal_space_vector.normalized()) +
			(p_sub_s * drags[s] * shepherd_avoidance_vector.normalized())
		)
		if (not_running):
			sheep_heading = (
				(h * drags[s] * inertia_vectors[s].normalized()) +
				(p_sub_a * personal_space_vector.normalized()) +
				(0.1 * wander_strengths[s] * wander_vectors[s].normalized())
			)
		
		if (not_running):
			drags[s] *= 0.998
			drags[s] = max(drags[s], 0.001)
			drags[s] = min(drags[s], 1.0)
		else:
			drags[s] *= 1.5
			drags[s] = max(drags[s], 0.01) # we want them to get moving faster
			drags[s] = min(drags[s], 1.0)
		
		inertia_vectors[s] = sheep_heading
		
		var local_speed: float = sheep_speed
		
		sheep[s].velocity = sheep_heading * local_speed
		sheep[s].queue_redraw()
		sheep[s].move_and_slide()
