extends Camera2D

@export var to_follow: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.global_position.x = to_follow.global_position.x
	self.global_position.y = to_follow.global_position.y
