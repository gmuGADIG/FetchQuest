extends Control

@onready var codex_progress_text: Label = %CodexProgressText
@onready var codex_progress_bar: ProgressBar = %CodexProgressBar

var codexProgress: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	codex_progress_text.text = "Codex Progress: " + str(codexProgress) 
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	testToggle()

#Probably will delete this and the "IncreaseCodexButton" node,
#but currently this increases the progress on the "CodexProgressText" label node and changes the progress bar.
func _on_increase_codex_button_pressed() -> void:
	codexProgress += 1
	codex_progress_text.text = "Codex Progress: " + str(codexProgress) + "/100" 
	codex_progress_bar.value = codexProgress

#Hides the codex UI and resumes the game, only called in testToggle() if the 'C' key is pressed.
func resume() -> void:
	hide()
	get_tree().paused = false

#Shows the codex UI and pauses the game, only called in testToggle() if the 'C' key is pressed.
func pause() -> void:
	show()
	get_tree().paused = true
	
#This checks whether or not to hide or show the UI based off of whether or not the "codex_toggle" key
#(currently the 'C' key) is pressed.
func testToggle() -> void:
	if(Input.is_action_just_pressed("codex_toggle") and get_tree().paused == false):
		pause()
	elif(Input.is_action_just_pressed("codex_toggle") and get_tree().paused == true):
		resume()
