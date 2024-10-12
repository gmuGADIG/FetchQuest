extends CharacterBody2D
class_name Item

@onready var pickup_area: Area2D = $PickupArea

enum ItemPhysicsState {
	FOLLOWING,
	IDLE
}

var physics_state: ItemPhysicsState = ItemPhysicsState.IDLE;

@export var acceleration: float = 50.0
@export var speed: float = 20.0

var target: Node2D

func _on_pickup_area_body_entered(other: Node2D) -> void:
	if (other.has_method("pickup_item")):
		other.pickup_item(self)
		
func follow(other: Node2D, follow_speed: float) -> void:
	target = other
	speed = follow_speed
	physics_state = ItemPhysicsState.FOLLOWING

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	match physics_state:
		ItemPhysicsState.FOLLOWING:
			if (is_instance_valid(target) and global_position.distance_to(target.global_position) <= 100):
				velocity = (target.global_position - global_position) * speed
			else:
				physics_state = ItemPhysicsState.IDLE
				target = null
		ItemPhysicsState.IDLE:
			var cur_speed: float = velocity.length()
			cur_speed = max(cur_speed - acceleration, 0)
			velocity = velocity.normalized() * cur_speed
	move_and_slide()
			
func consume(_consumer: Node2D) -> void:
	pass
