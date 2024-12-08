extends Node2D

## The distance in pixels that the enemy can "see" the player from
@export var detectable_distance:float = 250

## The raycast that we will be using to check the sightline of the enemy
@onready var raycast:RayCast2D = $DetectionRaycast

## actually tries to detect the player when true
var detecting := true

var can_see_player:bool = false

## A signal emitted once the player has been "seen"
signal player_detected

func _physics_process(_delta: float) -> void:
	if not detecting: 
		can_see_player = false
		return

	raycast.target_position = Vector2.RIGHT * detectable_distance
	raycast.look_at(Player.instance.global_position)
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		if not can_see_player:
			player_detected.emit()
		can_see_player = true
	else:
		can_see_player = false
