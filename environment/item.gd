extends RigidBody2D
class_name Item

@onready var pickup_area: TriggerArea = $PickupArea

var collector: Node2D

@export var can_be_picked_up: bool = true
@export var can_be_collected: bool = true

var physics_state: String = "idle"
var speed: float
var acceleration: float
var target: Node2D

func _ready() -> void:
	pickup_area.touched_by.connect(initiate_pickup)

func initiate_pickup(body: Node2D) -> void:
	pick_up(body)

func glue_to(body: Node2D, glue_strength: float) -> void:
	physics_state = "following"
	speed = glue_strength
	acceleration = 0
	target = body

func ignore_environment_collisions() -> void:
	set_collision_mask_value(1, false)  # Disable collision with certain layers (layer 1)
		
func pick_up(body: Node2D) -> void:
	if (body.has_method("pickup_item")):
		collector = body
		body.pickup_item(self)

func _physics_process(delta: float) -> void:
	match physics_state:
		"following":
			if target and is_instance_valid(target):
				apply_central_force((target.position - position) * speed)
