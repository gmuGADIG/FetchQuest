extends RichTextLabel


func _on_switch_activated() -> void:
	print(name + " recieved signal")
	text = "Switch activated"


func _on_switch_deactivated() -> void:
	print(name + " recieved signal")
	text = "Switch deactivated"
