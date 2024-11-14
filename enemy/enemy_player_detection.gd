extends Node2D

## The distance in pixels that the enemy can "see" the player from
@export var detectable_distance:float = 250

## The raycast that we will be using to check the sightline of the enemy
@onready var raycast:RayCast2D = $DetectionRaycast

## A variable that changes whether we are searching for the player or not
#var detecting:bool = true;

## The distance from our enemy to the player
var distance_to_player:float = 0

## Whether or not the player is within the detectable radius
var player_in_detection_zone:bool = false

var can_see_player:bool = false

## A signal emitted once the player has been "seen"
signal player_detected;

func _ready() -> void:
	## Set the Area2D size and raycast length to be our desired measurements
	raycast.target_position.x = detectable_distance

func _physics_process(_delta: float) -> void:
	## Update the distance to the player
	distance_to_player = abs(global_position.distance_to(Player.instance.global_position))	
	
	## Update whether the player is in the detection zone or not
	player_in_detection_zone = distance_to_player <= detectable_distance
	
	## Make sure we still want to detect the player and that it is close enough
	if player_in_detection_zone:
		# Make sure the raycast is always facing towards the player for line-of-sight check.
		raycast.look_at(Player.instance.global_position)
		
		## Check the raycast for the player's presence
		if (raycast.get_collider() as Player == Player.instance):
			##Emits an alert when the enemy first sees the player
			if(not can_see_player):
				player_detected.emit()
				can_see_player = true
		else:
			can_see_player = false
			
			

	
