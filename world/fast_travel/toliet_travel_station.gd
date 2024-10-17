extends Area2D

@export var map_scene : PackedScene

var toilet_location : String
var player: Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = Player.instance
	toilet_location = get_tree().current_scene.name
	
	print("Toilet is in " + toilet_location)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player in get_overlapping_bodies():
		FastTravelPoints.add_to_travel_points(toilet_location) #saves as new fast travel points
		print("Interacted with toilet")
		add_sibling(map_scene.instantiate())
	pass
