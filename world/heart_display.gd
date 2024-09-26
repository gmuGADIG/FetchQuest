extends HBoxContainer

var player : Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = Player.instance
	assert(player != null, "Player does not exist in the scene!")
	
	player.player_hurt.connect(onHurt)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func onHurt() -> void:
	print(player.health)
