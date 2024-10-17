class_name Animal
extends CharacterBody2D

@export var pen: AnimalPen = null
var speed: float = 200.0
var direction: Vector2 = Vector2(1, 0)
var panic: bool = false
var safe: bool = false
@export var normal_speed: float = 200.0
@export var safe_speed: float = 80.0
@export var panic_speed: float = 600.0
@export var panic_interval: float = 1.0

# move into panicked state from an event at the supplied position
func panic_from_position(pos: Vector2) -> void:
	if (panic or safe):
		return 
	panic = true
	$"Panic Timer".start(panic_interval * randi_range(2,5))
	speed = panic_speed
	
	# calculate a direction directly away from the supplied position
	direction = (self.global_position - pos).normalized() * 1.0

# stop panicking
func calm() -> void:
	panic = false
	$"Panic Timer".stop()
	speed = normal_speed

func _ready() -> void:
	direction = Vector2.from_angle(randf_range(0.0, 360.0)).normalized()
	pen.add_target_animal(self)

func _physics_process(delta: float) -> void:
	if (is_on_wall()):
		direction = direction.bounce(get_wall_normal())
	velocity = direction * speed
	
	move_and_slide()

# brain processing when in the pen
func think_when_safe() -> void:
	direction = Vector2.from_angle(randf_range(0.0, 360.0)).normalized()
	speed = randf_range(0.8, 1.1) * safe_speed

# brain processing when panicking
func think_when_panicking() -> void:
	# don't recalculate, just go in the direction we already want to go in
	pass

# brain processing when outside the pen
func think_when_normal() -> void:
	direction = Vector2.from_angle(randf_range(0.0, 360.0)).normalized()
	if (randi_range(0, 4) > 2):
		speed = randf_range(130.0, 220.0)
	else:
		speed = 0.0

# determine next objective
func _on_brain_timer_timeout() -> void:
	if (panic):
		think_when_panicking()
	elif (safe):
		think_when_safe()
	else:
		think_when_normal()

# calm down when the panic timer expires
func _on_panic_timer_timeout() -> void:
	calm()

# panic if something enters the panic area
func _on_area_2d_body_entered(body: Node2D) -> void:
	panic_from_position(body.global_position)

# called from the pen when an animal enters it for the first time
func enter_safe_area() -> void:
	if (safe):
		return
	safe = true
	calm()
	self.set_collision_mask_value(2, false)
	self.set_collision_mask_value(3, false)
	self.set_collision_mask_value(10, false)
	direction = ((self.global_position - pen.global_position) * -1.0).normalized()
	speed = safe_speed
	$"Brain Timer".stop()
	$"Brain Restart Timer".start(0.75)

# if the brain was shut down, restart it
func _on_brain_restart_timer_timeout() -> void:
	$"Brain Timer".start(2.5)

# if we leave the safe area, this gets called to make us go back inside
func retarget_safe_area() -> void:
	direction = ((self.global_position - pen.global_position) * -1.0).normalized()
