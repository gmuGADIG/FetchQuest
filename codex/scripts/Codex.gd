extends Control
@onready var codex_progress_text: Label = %CodexProgressText
@onready var codex_progress_bar: ProgressBar = %CodexProgressBar

@onready var codexTableOfContentsRightPage: Node = %TableOfContentsRight
@onready var codexTableOfContentsLeftPage: Node = %TableOfContentsLeft
@onready var codexLeftPage: Node = %CodexLeftPage

var codexProgress: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ShowTableOfContents()
	HideCodexPages()
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

#Hides the codex UI and resumes the game, only called in testToggle() if the 'C' key is pressed.
func resume() -> void:
	hide()
	ShowTableOfContents()
	HideCodexPages()
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

#Triggered by event - whenever one of the buttons in the table of contents or one of the back (maybe) buttons
#are pressed.
func _on_table_contents_button_pressed(index: int) -> void:
	#Ensures that only the pages we 100% want the player to see are shown
	HideTableOfContents()
	ShowCodexPages()
	
	#Inits the left page's references, title, image, and description
	codexLeftPage.SetPageComponents(0)
	
	var codexFilePath: String = CodexDatabase.GetCodexValue(str(index), "imageFilePath")
	codexLeftPage.SetPageImage(codexFilePath)
	
	var codexEntryTitle: String = CodexDatabase.GetCodexValue(str(index), "entryName")
	codexLeftPage.SetPageTitle(codexEntryTitle)
	
	var codexEntryDescription: String = CodexDatabase.GetCodexValue(str(index), "entryDescription")
	codexLeftPage.SetPageDescription(codexEntryDescription)
	
#Shows the table of contents to the player	
func ShowTableOfContents() -> void:
	codexTableOfContentsLeftPage.show()
	codexTableOfContentsRightPage.show()
	
#Hides both left and right pages of the table of contents from the player.
func HideTableOfContents() -> void:
	codexTableOfContentsLeftPage.hide()
	codexTableOfContentsRightPage.hide()
	
#Shows the main page(s) of the codex to the player.
func ShowCodexPages() -> void:
	codexLeftPage.show()
	
#Hides the main page(s) of the codex from the player.
func HideCodexPages() -> void:
	codexLeftPage.hide()

#TODO: When we actually implement this, this will, given an index, unlock that entry. What this will do is
#give the button corresponding to the entry some actual text, and make sure that button then does
func UnlockEntry(entryIndex: int) -> void:
	pass
