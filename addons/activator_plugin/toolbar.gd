@tool
class_name ActivatorPluginToolbar extends HBoxContainer

signal tool_button_toggled(toggled_on: bool)
@onready var button: Button = %Button

func _on_button_toggled(toggled_on: bool) -> void:
	tool_button_toggled.emit(toggled_on)
