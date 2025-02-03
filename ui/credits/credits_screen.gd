extends Control

# hide back button if not launched from title screen & send user back to town town
@onready var launched_from_title_screen := CreditsParams.launched_from_title_screen

func _ready() -> void:
	CreditsParams.reset()
	
	if not launched_from_title_screen:
		%BackButton.disabled = true
		%BackButton.visible = false
	else:
		%BackButton.grab_focus()


func _on_back_button_pressed() -> void:
	SceneTransition.change_scene(load("res://ui/title/title_screen.tscn"))


func _on_audio_stream_player_finished() -> void:
	if launched_from_title_screen:
		SceneTransition.change_scene(load("res://ui/title/title_screen.tscn"))
	else:
		SceneTransition.change_scene(SceneManager.get_packed_scene("town_town"))
