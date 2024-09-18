extends CharacterBody2D

var player: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	print("found player: ", player)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction := (player.global_position - global_position).normalized()
	velocity = direction * 20
	move_and_slide()
	pass
