extends Node
var codexEntries: Dictionary
var filePath: String = "res://codex/codexData/CodexEntries.json"

func SetFilePath(newFilePath: String) -> void:
	filePath = newFilePath
	
func _ready() -> void:
	ReadCodexEntries()
	
func GetDictionarySize() -> int:
	return codexEntries.size()
	
func ReadCodexEntries() -> void:
	var fileToRead: FileAccess = FileAccess.open(filePath, FileAccess.READ)
	
	var fileContent: String = fileToRead.get_as_text()
	codexEntries = JSON.parse_string(fileContent)

func GetCodexValue(entryIndex: String, fieldName: String) -> String:
	if not codexEntries.has(entryIndex):
		return codexEntries["default"][fieldName]
	
	return codexEntries[entryIndex][fieldName] if codexEntries[entryIndex].has(fieldName) else codexEntries["default"][fieldName]
