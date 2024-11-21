extends CanvasLayer

#Variables used by the audio player to play sounds!
@onready var button_major_sound: AudioStream = preload("res://ui/sounds/SFX UI Bonk 1.wav")
@onready var audio_player: AudioStreamPlayer = $PauseMenuAudioPlayer

func _ready() -> void:
	# The pause menu must always process. We can set this either in the inspector
	# or manually. TODO: Does setting it manually cause a problem if the pause
	# menu is instatiated into a new scene that is currently paused?
	process_mode = PROCESS_MODE_ALWAYS
	
	# We keep track of when the option menu is exited so that we can regrab
	# our focus (in this case of the options button).
	$OptionsMenu.option_menu_hidden.connect(self._on_option_menu_hidden)
	
	hide()
	
func _process(delta: float) -> void:
	
	#Ensures that if another menu is open that causes the game to be paused but it is NOT this one,
	#do nothing!
	if(get_tree().paused and not visible):
		return
		
	# NOTE: Right now, the pause menu is responsible for handling the pause hotkey,
	# -- this makes sense, because then the pause hotkey will work if and only if
	# the PauseMenu has been added to the scene.
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		
	var was_visible := visible
	
	# The pause menu's visibility is directly tied to whether the game is currently
	# paused. If we want to implement a pausing animation, this might have to change.
	visible = get_tree().paused
	
	# When the pause menu becomes newly visible, it grabs the focus and hides
	# the options menu. We hide the options menu first so that it's signal
	# doesn't affect us.
	if visible and not was_visible:
		$OptionsMenu.hide()
		$Panel/Resume.grab_focus()
		
	
func _on_resume_pressed() -> void:
	await audio_player.finised
	# When resume is pressed, we simply unpause.
	get_tree().paused = false
	
func _on_quit_pressed() -> void:
	await audio_player.finised
	# Unpause so that everything will work
	get_tree().paused = false
	# Go to main menu.
	SceneTransition.change_scene(preload("res://ui/title/title_screen.tscn"))
	
# When the option menu is hidden, we grab focus of the options button.
func _on_option_menu_hidden() -> void:
	$Panel/OptionsMenuButton.grab_focus()

#When a "major" button is pressed (the options, resume, and quit buttons in the pause menu), play their respective sounds!
#Called when a signal is recieved from the respective buttons
func _on_menu_major_button_pressed() -> void:
	audio_player.stream = button_major_sound
	audio_player.play(0.0)
