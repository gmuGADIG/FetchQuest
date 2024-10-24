extends TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Updates the heart display for the first time, then connects
	# to Player.health_changed signal for future updates
	Player.instance.stamina_changed.connect(update_stamina_display)
	update_stamina_display.call_deferred()
	value = 100

## Updates the heart display on the HUD
func update_stamina_display() -> void:
	value = (Player.instance.stamina / Player.instance.max_stamina) * 100
