extends CharacterBody2D

@export var walk_speed: float

var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	velocity = global_position.direction_to(player.global_position) * walk_speed
	move_and_slide()

func _on_health_died() -> void:
	queue_free()
