extends Area2D

@onready var red_coin_manager := $"../RedCoinManager"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	red_coin_manager._addRedCoin()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		#sound plays update UI?
		print("Picked up a coin")
		red_coin_manager._subtractRedCoin()
		queue_free()
	else:
		print("That isn't the player")
	
	pass # Replace with function body.
