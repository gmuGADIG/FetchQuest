extends Control
@onready var codex_progress_text: Label = %CodexProgressText
@onready var codex_progress_bar: ProgressBar = %CodexProgressBar
var codexProgress: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	codex_progress_text.text = "Codex Progress: " + str(codexProgress) 
	InitButtons()

#Inits the indicies for each of the buttons, this is important for knowing which button is being pressed
#when this script gets a signal that one of the buttons was pressed
func InitButtons() -> void:
	var buttonIndex: int = 1
	for codexButton in get_tree().get_nodes_in_group("PageButtons"):
		codexButton.SetIndex(buttonIndex)
		buttonIndex += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	testToggle()

#Probably will delete this and the "IncreaseCodexButton" node,
#but currently this increases the progress on the "CodexProgressText" label node and changes the progress bar.
func _on_box_enemy_button_pressed() -> void:
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

func _on_table_contents_button_pressed(index: int) -> void:
	print(str(index))

#TODO: When we actually implement this, this will, given an index, unlock that entry. What this will do is
#give the button corresponding to the entry some actual text, and make sure that button then does
func UnlockEntry(entryIndex: int) -> void:
	pass
