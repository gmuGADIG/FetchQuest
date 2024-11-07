class_name Animal
extends CharacterBody2D

@export var pen: AnimalPen = null
var speed: float = 200.0
var direction: Vector2 = Vector2(1, 0)
var panic: bool = false
var safe: bool = false
@export var normal_speed: float = 200.0
@export var safe_speed: float = 80.0

# version 2! turns out the 'shepherd and sheep problem' isn't that uncommon!
# redesigning it to work off that instead of the way it works now

var shepherd: Player
var r_sheep_vector: Vector2
var r_shepherd_vector: Vector2
var wander_vector: Vector2
var aware_of_shepherd: int = 0
@export var repulsion_from_sheep: float = 1.0
@export var repulsion_from_shepherd: float = 3.0
@export var wandering_force: float = 0.5
@export var nearest_neighbors_to_consider: int = 3

var shepherd_circle_radius: float = 1.0
var personal_circle_radius: float = 1.0


@export var debug_draw: bool = false
var do_draw_av: bool = false
var avoidance_vector: Vector2 = Vector2.ZERO
var do_draw_sv: bool = false
var shepherd_position: Vector2 = Vector2.ZERO
var do_draw_herd: bool = true
var herd_LCM: Vector2 = Vector2.ZERO
var herd_vector: Vector2 = Vector2.ZERO

func draw_avoidance_vector(av: Vector2) -> void:
	do_draw_av = true
	avoidance_vector = av
	queue_redraw()

func draw_shepherd_vector(sv: Vector2) -> void:
	do_draw_sv = true
	shepherd_position = sv
	queue_redraw()

func draw_herding_info(hp: Vector2, hv: Vector2) -> void:
	do_draw_herd = true
	herd_LCM = hp
	herd_vector = hv
	queue_redraw()

func _draw() -> void:
	if (debug_draw == false):
		pass
		#return
	
	draw_circle(Vector2(0, 0), shepherd_circle_radius, Color.GREEN, false)
	draw_circle(Vector2(0, 0), personal_circle_radius, Color.RED, false)
	
	if (do_draw_av):
		do_draw_av = false
		draw_line(Vector2(0, 0), (self.avoidance_vector), Color.BLUE_VIOLET, 10.0)
		avoidance_vector = Vector2.ZERO
	if (do_draw_sv):
		do_draw_sv = false
		draw_line(Vector2(0, 0), to_local(shepherd_position), Color.BLUE)
		shepherd_position = Vector2.ZERO
	if do_draw_herd:
		do_draw_herd = false
		draw_circle(herd_LCM, 15.0, Color.GREEN)
		draw_line(Vector2(0, 0), herd_LCM, Color.GREEN_YELLOW)

# called from the pen when an animal enters it for the first time
func enter_safe_area() -> void:
	if (safe):
		return
	safe = true
	self.set_collision_mask_value(2, false)
	self.set_collision_mask_value(3, false)
	self.set_collision_mask_value(10, false)
	direction = ((self.global_position - pen.global_position) * -1.0).normalized()
	speed = safe_speed
