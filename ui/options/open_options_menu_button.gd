extends Button

@export var options_menu: Node

func _ready() -> void:
	assert(options_menu != null, "options_menu must be assigned")
	
	# When we init, the options menu is hidden -- then the button will show it.
	options_menu.hide()
	
	self.pressed.connect(self._on_self_pressed)
	
# When the button is pressed, we simply show the menu. Maybe one day we will
# have an animation for this.
func _on_self_pressed() -> void:
	options_menu.show()
	
