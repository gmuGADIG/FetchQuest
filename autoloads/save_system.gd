extends Node

const save_path := "user://save.dat"

@onready var default_save := _create_save_dictionary()

## store data to the filesystem.
## returns true if successful
func store_dictionary(path: String, d: Dictionary) -> bool:
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		push_error("[save_system] failed writing to %s" % path)
		return false
	
	f.store_var(d, true)
	f.flush()
	return true

## read data from the filesystem.
## returns empty dictionary on failure
func get_dictionary(path: String) -> Dictionary:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		push_error("[save_system] failed reading to %s" % path)
		return {}

	return f.get_var(true)

func _create_save_dictionary() -> Dictionary:
	var location := {
		last_scene_path = get_tree().current_scene.scene_file_path,
		last_entry_point = EntryPoints.last_entry_point
	}

	# TODO: handle any unique quest data, if it will ever exist
	var quests := {}
	for quest in QuestSystem.quests:
		quests[quest.quest_id] = quest.state

	var fast_travel_points: Array[Dictionary]
	for tp in FastTravelPoints.unlocked_fast_travel_points:
		fast_travel_points.append({
			scene = tp.scene_name,
			entry_point = tp.entry_point_name
		})

	var save := {
		location = location,
		inventory = PlayerInventory.serialize(),
		chests = ChestBetweenScenes.opened_chest,
		quests = quests,
		fast_travel_points = fast_travel_points,
		chosen_skin = Skins.chosen_skin,
		dialogic = Dialogic.get_full_state(),
		talking_interactable = TalkingInteractable.save_data
	}

	# print("[save_system] save.dialogic = ", save.dialogic)
	return save

func _handle_save_dictionary(save: Dictionary) -> void:
	Skins.chosen_skin = save.chosen_skin

	for tp: Dictionary in save.fast_travel_points:
		var travel_point := TravelPoint.new(tp.scene, tp.entry_point)
		if not FastTravelPoints.point_unlocked(travel_point):
			FastTravelPoints.add_to_travel_points(travel_point)
	
	for quest_id: String in save.quests.keys():
		var state: Quest.State = save.quests[quest_id]
		var quest := QuestSystem._find_quest_by_id(quest_id)

		quest.state = state
		if state == Quest.State.ASSIGNED:
			quest._assign_hook()
	
	ChestBetweenScenes.opened_chest = save.chests

	PlayerInventory.deserialize(save.inventory)

	Dialogic.load_full_state(save.dialogic)

	TalkingInteractable.save_data = save.talking_interactable

func save_game() -> void:
	print("[save_system] saving game")
	store_dictionary(save_path, _create_save_dictionary())

func load_game() -> void:
	# TODO: handle no save
	print("[save_system] loading game")
	
	var save := get_dictionary(save_path)
	_handle_save_dictionary(save)

	EntryPoints.current_entry_point = save.location.last_entry_point
	SceneTransition.change_scene(load(save.location.last_scene_path))

func new_game() -> void:
	print("[save_system] creating new game")
	_handle_save_dictionary(default_save)

## returns true if a valid save exists
func save_valid() -> bool:
	return FileAccess.file_exists(save_path)
