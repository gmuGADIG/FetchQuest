extends CharacterBody2D

@export var speed: float = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * speed
	
	if Input.is_action_just_pressed("attack"):
		throw_weapon()
	
	move_and_slide()
	pass

func throw_weapon() -> void:
	var sword_scene := preload("res://Sword/sword.tscn")
	var sword := sword_scene.instantiate()
	add_sibling(sword)
	sword.global_position = global_position
	pass
