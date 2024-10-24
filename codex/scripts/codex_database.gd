extends Node
var codex_entries: Dictionary
var file_path: String = "res://codex/codexData/codex_entries.json"

func set_file_ath(new_file_path: String) -> void:
	file_path = new_file_path
	
func _ready() -> void:
	read_codex_entries()
	
func get_dictionary_size() -> int:
	return codex_entries.size()
	
func read_codex_entries() -> void:
	var file_to_read: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	
	var file_content: String = file_to_read.get_as_text()
	codex_entries = JSON.parse_string(file_content)

func unlock_entry(index: int) -> void:
	codex_entries[str(index)]["unlocked"] = "true"
	
func get_codex_value(entry_index: String, field_name: String) -> String:
	if not codex_entries.has(entry_index):
		return codex_entries["default"][field_name]
	
	return codex_entries[entry_index][field_name] if codex_entries[entry_index].has(field_name) else codex_entries["default"][field_name]
