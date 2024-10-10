extends Node2D

@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D
@onready var moveForward : bool = true
# How fast we want the wall to move
@export var speed  : int = 100
@export var bouncing : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bouncing:
		if moveForward:
			if path_follow.progress_ratio < 1:
				path_follow.progress_ratio += speed * delta 
			if path_follow.progress_ratio == 1:
				moveForward = false
		else:
			if path_follow.progress_ratio > 0:
				path_follow.progress_ratio -= speed * delta 
			if path_follow.progress_ratio == 0:
				moveForward = true
			
	else:
		if path_follow.progress_ratio < 1:
			path_follow.progress_ratio += speed * delta 
			
		
		
		
