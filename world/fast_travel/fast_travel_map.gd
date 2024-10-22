extends CanvasLayer

func _ready() -> void:
	get_tree().paused = true;

func _on_tree_exit() -> void:
	get_tree().paused = false;

func _on_resume_pressed() -> void:
	get_tree().paused = false;
	queue_free();
