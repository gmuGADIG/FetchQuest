extends Area2D

## The distance in pixels that the enemy can "see" the player from
@export var detectable_distance:float = 250

## The raycast that we will be using to check the sightline of the enemy
@onready var raycast:RayCast2D = $DetectionRaycast

## A variable that changes whether we are searching for the player or not
var detecting:bool = true;

## The distance from our enemy to the player
var distance_to_player:float = 0

## A signal emitted once the player has been "seen"
signal player_detected;

func _ready() -> void:
	## Set the Area2D size and raycast length to be our desired measurements
	$DetectionZone.shape.radius = detectable_distance
	raycast.target_position.x = detectable_distance

func _physics_process(delta: float) -> void:
	## Update the distance to the player
	distance_to_player = abs(global_position.distance_to(Player.instance.global_position))	

	## Make sure we still want to detect the player
	if detecting:
		## Check both the area2d and the raycast for the player's presence
		if overlaps_body(Player.instance) and (raycast.get_collider() as Player == Player.instance):
				## Emit the signal upon detecting the player
				player_detected.emit()


func _on_player_detected() -> void:
	## NOTE: The following code is temporary functionality and will likely not be staying
	## Disable detection of player
	detecting = false;
	## Print to the console that the player was detected by the enemy
	print("enemy_player_detection.gd: \'",get_parent().name, "\' detected player")
