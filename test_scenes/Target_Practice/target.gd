extends Node2D

@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D

@export var speed:= 100
@export var target_node: Node2D

var dir: bool = false
var go: bool = false

#func _ready() -> void:
	# Manually connect the signal if needed
	#self.connect("body_entered", self, "_on_Area2D_body_entered")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if go == true:
		if dir == false:
			path_follow.progress += speed * delta
			if path_follow.progress > 600:
				dir = true
		else:	
			path_follow.progress -= speed * delta
			if path_follow.progress < 3:
				dir = false
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("yousure?")
	go = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	#shutdown method yet to be implemeted to reset everything upon exited area
	go = false
