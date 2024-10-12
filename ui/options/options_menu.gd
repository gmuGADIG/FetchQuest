extends ColorRect

signal option_menu_hidden

func _ready() -> void:
	self.visibility_changed.connect(self._on_own_visibility_changed)
	
# When the option menu becomes visible, grab the focus of the back button.
# We will need to grab the focus of the containing menu's controls again
# when we go back.
func _on_own_visibility_changed() -> void:
	if self.visible:
		$Back_To_Menu.grab_focus()
	else:
		# When the option menu is hidden, emit a signal, 
		option_menu_hidden.emit()
