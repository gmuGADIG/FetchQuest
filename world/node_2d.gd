extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		print("You stepped on a weak part of the floor!")
		Player.instance.hurt(DamageEvent.new(1))
		
		
