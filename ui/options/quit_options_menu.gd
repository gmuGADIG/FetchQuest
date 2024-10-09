extends Button

func _ready() -> void:
	self.pressed.connect(self._on_self_pressed)

func _on_self_pressed() -> void:
	get_parent().hide()
