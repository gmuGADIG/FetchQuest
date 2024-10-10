extends Node2D

@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D

@export var speed:= 100
@export var target_node: Node2D
@export var collision_zone: Area2D
@export var player: CharacterBody2D
@export var target_collision: CollisionShape2D
@export var sprite: Sprite2D

var dir: bool = false
var go: bool = false

func _ready() -> 	void:
	
	collision_zone.connect("body_shape_entered", Callable(self, "_on_body_shape_entered"))
	collision_zone.connect("body_shape_exited", Callable(self, "_on_body_shape_exited"))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	target_collision.global_position = sprite.global_position
	if go == true:
		if dir == false:
			path_follow.progress += speed * delta
			if path_follow.progress > 600:
				dir = true
		else:	
			path_follow.progress -= speed * delta
			if path_follow.progress < 3:
				dir = false
	

func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	print("yousure?")	
	go = true

func _on_body_shape_exited(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	#shutdown method yet to be implemeted to reset everything upon exited area
	go = false
	path_follow.progress = 0.0
