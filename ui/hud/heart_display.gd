extends HBoxContainer

@onready var heart : PackedScene = load("uid://crx66rsu01asx")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Updates the heart display for the first time, then connects
	# to Player.health_changed signal for future updates
	Player.instance.health_changed.connect(update_heart_display)
	update_heart_display.call_deferred()

## Updates the heart display on the HUD
func update_heart_display() -> void:
	
	# Remove all the children first
	for _child in get_children():
		remove_child(_child)
		_child.queue_free()
	
	# Then add in the amount of hearts back
	for h in Player.instance.health:
		add_child(heart.instantiate())
		
	# NOTE: A better way to do this might be to remove the amount of
	# hearts needed, but this implementation is sufficient for any
	# amount of health lost (aka intended to be robust/future-proof)
