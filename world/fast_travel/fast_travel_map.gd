extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tree_exit() -> void:
	get_tree().paused = false;
	pass # Replace with function body.


func _on_resume_pressed() -> void:
	get_tree().paused = false;
	queue_free();
	pass # Replace with function body.
