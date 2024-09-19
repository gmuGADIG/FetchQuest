extends CanvasLayer

func _ready() -> void:
	# The pause menu must always process. We can set this either in the inspector
	# or manually. TODO: Does setting it manually cause a problem if the pause
	# menu is instatiated into a new scene that is currently paused?
	process_mode = PROCESS_MODE_ALWAYS
	hide()
	
func _process(delta: float) -> void:
	# NOTE: Right now, the pause menu is responsible for handling the pause hotkey,
	# -- this makes sense, because then the pause hotkey will work if and only if
	# the PauseMenu has been added to the scene.
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
	
	# The pause menu's visibility is directly tied to whether the game is currently
	# paused. If we want to implement a pausing animation, this might have to change.
	visible = get_tree().paused
	
func _on_resume_pressed() -> void:
	# When resume is pressed, we simply unpause.
	get_tree().paused = false
	
	
