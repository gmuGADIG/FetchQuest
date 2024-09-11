class_name Player extends CharacterBody2D

@export var speed: float
@export var throw_speed: float

func _ready() -> void:
	print("player ready")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		throw_sword()
	
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * speed
	
	move_and_slide()

func throw_sword() -> void:
	# instantiate sword
	var sword_node: ThrownSword = preload("res://player/thrown_sword/thrown_sword.tscn").instantiate()
	get_tree().current_scene.add_child(sword_node)
	sword_node.global_position = global_position
	
	# calculate throw velocity
	var direction := global_position.direction_to(get_global_mouse_position())
	
	# throw it
	sword_node.throw(direction * throw_speed)
