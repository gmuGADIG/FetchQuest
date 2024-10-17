extends Panel

#The three components of this page: the title, the image associated with the entry, and the description.
var page_image: Sprite2D
var page_title_label: Label
var page_description_label: Label
var page_number_label: Label

#Given an int describing which side of the screen this page will be on (0 for left, 1 for right), sets the
#pageImage, pageTitleLabel, and pageDescriptionLabel references accordingly.
func set_page_components(pageSide: int) -> void:
	if(pageSide == 0):
		page_image = $LeftPageImage
		page_title_label = $LeftPageTitle
		page_description_label = $LeftPageDescription
		page_number_label = $LeftPageNumber
	else:
		page_image = $RightPageImage
		page_title_label = $RightPageTitle
		page_description_label = $RightPageDescription
		page_number_label = $RightPageNumber
		
func set_page_index(index: int) -> void:
	var codex_file_path: String = codex_database.get_codex_value(str(index), "imageFilePath")
	set_page_image(codex_file_path)
		
	var codex_entry_title: String = codex_database.get_codex_value(str(index), "entryName")
	set_page_title(codex_entry_title)
		
	var codex_entry_description: String = codex_database.get_codex_value(str(index), "entryDescription")
	set_page_description(codex_entry_description)
		
	set_page_number(str(index))

#Given a path that contains the desired image, sets this page's image to be located at that path.
func set_page_image(image_file_path: String) -> void:
	page_image.texture = load(image_file_path)
	pass
	
#Sets the title for this page to be the input.
func set_page_title(entry_title: String) -> void:
	page_title_label.text = entry_title
	pass

#Sets the description for the entry for this page to be the input.
func set_page_description(entry_description: String) -> void:
	page_description_label.text = entry_description
	pass

func set_page_number(page_number: String) -> void:
	page_number_label.text = page_number
