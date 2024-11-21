extends ColorRect

#The variables used by the sound player for playing the sounds for the buttons
@onready var button_major_sound: AudioStream = preload("res://ui/sounds/SFX UI Bonk 1.wav")
@onready var button_minor_sound: AudioStream = preload("res://ui/sounds/SFX UI Click 1.wav")
@onready var audio_player: AudioStreamPlayer = $OptionsMenuSoundPlayer

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
	
#When a major (the back to menu button in the options menu case) button is pressed, play the respective sound
#Called when a signal is recieved from the respective buttons/sliders
func _on_menu_major_button_pressed() -> void:
	audio_player.stream = button_major_sound
	audio_player.play(0.0)
	
#When a minor (the sliders) button/slider is pressed or released, play the respective sound
#Called when a signal is recieved from the respective buttons/sliders
func _on_menu_minor_button_pressed() -> void:
	audio_player.stream = button_minor_sound
	audio_player.play(0.0)
