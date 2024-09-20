extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ready")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func recieve_signal() -> void:
	print("Recieved signal")
	self.texture.gradient.set_color(1, Color.WHEAT)


func _on_switch_switch_activated() -> void:
	recieve_signal()
