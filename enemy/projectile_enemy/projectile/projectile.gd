extends CharacterBody2D

@export var speed : float = 500.0
@export var damage : int = 1
@export var despawn_time : float = 5.0

var _despawn_timer : float = 0.0
func _ready() -> void:
	velocity = Vector2.RIGHT.rotated(rotation) * speed
	
	
func _physics_process(delta: float) -> void:
	
	move_and_slide()
	for i in get_slide_collision_count():
		var collision : KinematicCollision2D = get_slide_collision(i)
		print("Collided with: ", collision.get_collider().name)
		hit(collision)
		
	_despawn_timer += delta
	if _despawn_timer > despawn_time:
		queue_free()
		
		
func hit(collision: KinematicCollision2D) -> void:
	queue_free()
	pass
