extends CharacterBody2D

@export var move_speed: float = 500.0
@export var push_velocity: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(_delta: float) -> void:
	push_velocity *= 0.95
	velocity = push_velocity
	move_and_slide()
	
	$Area2D.get_overlapping_bodies()
	

func _on_pushing_area_body_entered(body: Node2D) -> void:
	var player := body as Player
	if player != null:
		push_velocity = player.velocity.normalized()
		
		if abs(push_velocity.x) > abs(push_velocity.y):
			push_velocity.y = 0;
		else:
			push_velocity.x = 0;
		push_velocity = push_velocity.normalized() * move_speed
