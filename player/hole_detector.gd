extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	Player.instance.hurt(DamageEvent.new(1))
	Player.instance.position -= Player.instance.global_position.direction_to(body.global_position) * 200
