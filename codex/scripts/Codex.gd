extends Control
## For anyone not faimilar with this file, READ HERE!!!!!!!!!!
# This script only manages the codex menu itself, it does NOT really involve getting the entry data (title, image,
# description) and setting the pages of the codex to reflect that information. Getting the codex information from
# the relevant json file(s) is handled in the codex_database script, the buttons in the table of contents telling
# this script which page to go to is handled in the codex_button script, and the setting of the contents of the 
# page to reflect the page the player wants to see is handled in the codex_page script. 

# The relevant nodes in the table of contents part of the codex.
@onready var codex_progress_text: Label = %CodexProgressText
@onready var codex_progress_bar: ProgressBar = %CodexProgressBar
@onready var codex_table_of_contents_right_page: Node = %TableOfContentsRight
@onready var codex_table_of_contents_left_page: Node = %TableOfContentsLeft

# The left and right pages of the codex, the two pages to contain the entry the player wants to look at.
@onready var codex_left_page: Node = %CodexLeftPage
@onready var codex_right_page: Node = %CodexRightPage

# These are to handle the indecies (no idea if I spelled that right) of the two pages we are displaying.
var left_page_index: int = 0
var right_page_index: int = 0

# Just the amount of codex entries the player has unlocked. Not really needed, but nice to have
var codex_progress: int = 0

# Called when the node enters the scene tree for the first time. This makes sure the sections of the codex UI
# we want to see are the ones shown.
func _ready() -> void:
	show_table_of_contents()
	hide_codex_pages()
	hide()
	codex_progress_text.text = "Codex Progress: " + str(codex_progress) 
	init_buttons()
	
	#Inits the left page's references, title, image, and description
	codex_left_page.set_page_components(0)
	codex_right_page.set_page_components(1)

#Inits the indicies for each of the buttons, this is important for knowing which button is being pressed
#when this script gets a signal that one of the buttons was pressed.
func init_buttons() -> void:
	var button_index: int = 1
	for codex_button in get_tree().get_nodes_in_group("PageButtons"):
		codex_button.set_index(button_index)
		button_index += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	test_toggle()

#Hides the codex UI and resumes the game, only called in testToggle() if the 'C' key is pressed.
func resume() -> void:
	if(get_tree().paused and not visible):
		return
	visible = false
	show_table_of_contents()
	hide_codex_pages()
	get_tree().paused = false

#Shows the codex UI and pauses the game, only called in testToggle() if the 'C' key is pressed.
func pause() -> void:
	if(get_tree().paused):
		return
	visible = true
	get_tree().paused = true
	
#This checks whether or not to hide or show the UI based off of whether or not the "codex_toggle" key
#(currently the 'C' key) is pressed.
func test_toggle() -> void:
	if(Input.is_action_just_pressed("codex_toggle") and get_tree().paused == false):
		pause()
	elif(Input.is_action_just_pressed("codex_toggle") and get_tree().paused == true):
		resume()

#Triggered by event - whenever one of the buttons in the table of contents or one of the back (maybe) buttons
#are pressed.
func _on_table_contents_button_pressed(index: int) -> void:
	#Ensures that only the pages we 100% want the player to see are shown
	hide_table_of_contents()
	show_codex_pages()
	
	left_page_index = 0
	right_page_index = 0
	
	left_page_index = find_first_page_index(index)
	right_page_index = find_first_page_index(left_page_index + 1)
	
	codex_left_page.set_page_index(left_page_index)
	codex_right_page.set_page_index(right_page_index)
		
# Given an index, finds the first codex entry that is unlocked, starting at that index. Used to know which codex
# entries we want to show to the player.
func find_first_page_index(starting_index: int) -> int:
	for entry_index in range(starting_index, codex_database.get_dictionary_size()):
		var unlocked: bool = codex_database.get_codex_value(str(entry_index), "unlocked") == "true"
		if(unlocked):
			if(left_page_index == 0):
				left_page_index = entry_index
			else:
				right_page_index = entry_index
			return entry_index
	return -1
				
	
#Shows the table of contents to the player	
func show_table_of_contents() -> void:
	codex_table_of_contents_left_page.show()
	codex_table_of_contents_right_page.show()
	
#Hides both left and right pages of the table of contents from the player.
func hide_table_of_contents() -> void:
	codex_table_of_contents_left_page.hide()
	codex_table_of_contents_right_page.hide()
	
#Shows the main page(s) of the codex to the player.
func show_codex_pages() -> void:
	codex_left_page.show()
	codex_right_page.show()
	
#Hides the main page(s) of the codex from the player.
func hide_codex_pages() -> void:
	codex_left_page.hide()
	codex_right_page.hide()

#TODO: When we actually implement this, this will, given an index, unlock that entry. What this will do is
#give the button corresponding to the entry some actual text, and make sure that button then does
func UnlockEntry(entryIndex: int) -> void:
	pass
