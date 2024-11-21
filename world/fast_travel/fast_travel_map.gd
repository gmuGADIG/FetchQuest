extends CanvasLayer

#if we pause it here then we can't pause it when the pause menu comes up
func _ready() -> void:
	#get_tree().paused = true;
	pass

func _on_tree_exit() -> void:
	#get_tree().paused = false;
	pass

func _on_resume_pressed() -> void:
	#get_tree().paused = false;
	queue_free();
	#pass
