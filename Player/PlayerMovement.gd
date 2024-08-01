extends Node2D
@export var move_speed: float = 250.0
@onready var player: CharacterBody2D = get_parent()


func _physics_process(_delta):
	var horizontal := Input.get_axis("move_left", "move_right")
	var vertical := Input.get_axis("move_up", "move_down")
	
	player.velocity = Vector2(horizontal, vertical).normalized() * move_speed
	
	player.move_and_slide()
