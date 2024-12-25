class_name King extends Node2D

@export var movement_points:Array[Node2D]
@onready var previous_teleport_position:Vector2 = global_position
func randomly_move() -> void:
	while global_position == previous_teleport_position:
		global_position = movement_points.pick_random().global_position
	previous_teleport_position = global_position


func _on_random_teleport_timer_timeout() -> void:
	randomly_move()
