extends HBoxContainer

var player : Player
@onready var heart : PackedScene = load("uid://crx66rsu01asx")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Finds and makes sure that the player is indeed exist
	player = Player.instance
	assert(player != null, "Player does not exist in the scene!")
	
	# Updates the heart display for the first time, then connects
	# to Player.health_changed signal for future updates
	update_heart_display()
	player.health_changed.connect(update_heart_display)

## Updates the heart display on the HUD
func update_heart_display() -> void:
	
	# Remove all the children first
	for _child in get_children():
		remove_child(_child)
		_child.queue_free()
	
	# Then add in the amount of hearts back
	for h in player.health:
		add_child(heart.instantiate())
		
	# NOTE: A better way to do this might be to remove the amount of
	# hearts needed, but this implementation is sufficient for any
	# amount of health lost (aka intended to be robust/future-proof)
