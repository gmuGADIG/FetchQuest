extends Node2D

## The distance in pixels that the enemy can "see" the player from
@export var detectable_distance:float = 250

## The raycast that we will be using to check the sightline of the enemy
@onready var raycast:RayCast2D = $DetectionRaycast

## A variable that changes whether we are searching for the player or not
var detecting:bool = true;

## The distance from our enemy to the player
var distance_to_player:float = 0

## Whether or not the player is within the detectable radius
var player_in_detection_zone:bool = false

## A signal emitted once the player has been "seen"
signal player_detected;

func _ready() -> void:
	## Set the Area2D size and raycast length to be our desired measurements
	raycast.target_position.x = detectable_distance

func _physics_process(delta: float) -> void:
	## Update the distance to the player
	distance_to_player = abs(global_position.distance_to(Player.instance.global_position))	
	
	## Update whether the player is in the detection zone or not
	player_in_detection_zone = distance_to_player <= detectable_distance
	
	## Make sure we still want to detect the player and that it is close enough
	if detecting and player_in_detection_zone:
		## Check the raycast for the player's presence
		if (raycast.get_collider() as Player == Player.instance):
				## Emit the signal upon detecting the player
				player_detected.emit()


func _on_player_detected() -> void:
	## NOTE: The following code is temporary functionality and will likely not be staying
	## Disable detection of player
	detecting = false;
	## Print to the console that the player was detected by the enemy
	print("enemy_player_detection.gd: \'",get_parent().name, "\' detected player")
