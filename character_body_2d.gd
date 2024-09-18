extends CharacterBody2D

@export var speed : Vector2 = Vector2(0,0) 

func _ready() -> void:
	var x: int = 10
	#print("FUCK")
	pass

func _process(delta: float) -> void:
	#if Input.is_action_pressed("move_down"):
	#	velocity += Vector2(0,3)
	#if Input.is_action_pressed("move_up"):
	#	velocity += Vector2(0,-3)
	#if Input.is_action_pressed("move_right"):
	#	velocity += Vector2(3,0)
	#if Input.is_action_pressed("move_left"):
	#	velocity += Vector2(-3,0)
	var v : Vector2 = Input.get_vector("move_left","move_right","move_up", "move_down")
	if v.x == 0.0 && v.y == 0:
		velocity -= velocity / 8
	else:
		velocity += v
	move_and_slide()
	print(v.normalized())
	pass
