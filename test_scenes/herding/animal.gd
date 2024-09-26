class_name Animal
extends CharacterBody2D

var speed: float = 200.0
var direction: Vector2 = Vector2(1, 0)
var panic: bool = false
var safe: bool = false
@export var normal_speed: float = 200.0
@export var safe_speed: float = 80.0
@export var panic_speed: float = 600.0
@export var panic_interval: float = 1.0

@export var pen_object: Area2D

func panic_from_position(pos: Vector2) -> void:
	if (panic or safe):
		return 
	panic = true
	$"Panic Timer".start(panic_interval * randi_range(2,5))
	speed = panic_speed
	
	# calculate a direction directly away from the supplied position
	direction = (self.global_position - pos).normalized() * 1.0

func calm() -> void:
	panic = false
	$"Panic Timer".stop()
	speed = normal_speed

func _ready() -> void:
	direction = Vector2.from_angle(randf_range(0.0, 360.0)).normalized()
	if (pen_object):
		pen_object.body_entered.connect(_on_entered_safe_area)
		pen_object.body_exited.connect(_on_leave_pen)

func _physics_process(delta: float) -> void:
	if (is_on_wall()):
		direction = direction.bounce(get_wall_normal())
	velocity = direction * speed
	
	move_and_slide()

func _on_brain_timer_timeout() -> void:
	print(safe)
	print("brain time")
	if (panic):
		return
	elif (safe):
		direction = Vector2.from_angle(randf_range(0.0, 360.0)).normalized()
		speed = randf_range(0.8, 1.1) * safe_speed
	else:
		direction = Vector2.from_angle(randf_range(0.0, 360.0)).normalized()
		if (randi_range(0, 4) > 2):
			speed = randf_range(130.0, 220.0)
		else:
			speed = 0.0

# calm down when the panic timer expires
func _on_panic_timer_timeout() -> void:
	calm()

# panic if something enters the panic area
func _on_area_2d_body_entered(body: Node2D) -> void:
	panic_from_position(body.global_position)

# entered the safe area
func _on_entered_safe_area(body: Node2D) -> void:
	print("hello?????")
	if (safe):
		return
	safe = true
	calm()
	self.set_collision_mask_value(2, false)
	self.set_collision_mask_value(3, false)
	self.set_collision_mask_value(8, false)
	direction = ((self.global_position - pen_object.global_position) * -1.0).normalized()
	speed = safe_speed
	$"Brain Timer".stop()
	$"Brain Restart Timer".start(0.75)

func _on_leave_pen(body: Node2D) -> void:
	direction = ((self.global_position - pen_object.global_position) * -1.0).normalized()

func _on_brain_restart_timer_timeout() -> void:
	$"Brain Timer".start(2.5)
