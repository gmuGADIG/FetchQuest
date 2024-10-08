extends Area2D

@export var detectable_distance:float = 250
@onready var raycast:RayCast2D = $DetectionRaycast
var detecting:bool = true;
var distance_to_player:float = 0

signal player_detected;

func _ready() -> void:
	$DetectionZone.shape.radius = detectable_distance
	$DetectionRaycast.target_position.x = detectable_distance

func _physics_process(delta: float) -> void:
	distance_to_player = abs(global_position.distance_to(Player.instance.global_position))	
	if detecting:
		if overlaps_body(Player.instance) and (raycast.get_collider() as Player == Player.instance):
				player_detected.emit()


func _on_player_detected() -> void:
	detecting = false;
