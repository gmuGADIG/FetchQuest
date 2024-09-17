extends RigidBody2D
class_name Item

@onready var pickup_area: TriggerArea = $PickupArea

var collector: Node2D

@export var can_be_picked_up: bool = true
@export var can_be_collected: bool = true;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pickup_area.touched_by.connect(initiate_pickup)

func initiate_pickup(body: Node2D) -> void:
	if can_be_collected and body is Player:
		queue_free()
	elif can_be_picked_up and body is ThrownSword:
		collect(body)
		
func collect(body: Node2D) -> void:
	collector = body
	apply_central_force((collector.position - position).normalized() * collector.get_velocity().length() * 1.2)
		
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if collector and is_instance_valid(collector):
		state.linear_velocity = (collector.position - position).normalized() * collector.get_velocity().length() * 1.2
