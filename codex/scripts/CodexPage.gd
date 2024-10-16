extends Panel

#The three components of this page: the title, the image associated with the entry, and the description.
var pageImage: Sprite2D
var pageTitleLabel: Label
var pageDescriptionLabel: Label
var pageNumberLabel: Label

#Given an int describing which side of the screen this page will be on (0 for left, 1 for right), sets the
#pageImage, pageTitleLabel, and pageDescriptionLabel references accordingly.
func SetPageComponents(pageSide: int) -> void:
	if(pageSide == 0):
		pageImage = $LeftPageImage
		pageTitleLabel = $LeftPageTitle
		pageDescriptionLabel = $LeftPageDescription
		pageNumberLabel = $LeftPageNumber
	else:
		pageImage = $RightPageImage
		pageTitleLabel = $RightPageTitle
		pageDescriptionLabel = $RightPageDescription
		pageNumberLabel = $RightPageNumber
		
func SetPageIndex(index: int) -> void:
	var codexFilePath: String = CodexDatabase.GetCodexValue(str(index), "imageFilePath")
	SetPageImage(codexFilePath)
		
	var codexEntryTitle: String = CodexDatabase.GetCodexValue(str(index), "entryName")
	SetPageTitle(codexEntryTitle)
		
	var codexEntryDescription: String = CodexDatabase.GetCodexValue(str(index), "entryDescription")
	SetPageDescription(codexEntryDescription)
		
	SetPageNumber(str(index))

#Given a path that contains the desired image, sets this page's image to be located at that path.
func SetPageImage(imageFilePath: String) -> void:
	pageImage.texture = load(imageFilePath)
	pass
	
#Sets the title for this page to be the input.
func SetPageTitle(entryTitle: String) -> void:
	pageTitleLabel.text = entryTitle
	pass

#Sets the description for the entry for this page to be the input.
func SetPageDescription(entryDescription: String) -> void:
	pageDescriptionLabel.text = entryDescription
	pass

func SetPageNumber(pageNumber: String) -> void:
	pageNumberLabel.text = pageNumber
