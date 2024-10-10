extends Area2D

@export var map_scene : PackedScene
var player: Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = Player.instance
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player in get_overlapping_bodies():
		print("Interacted with toilet")
		add_sibling(map_scene.instantiate())
	pass
