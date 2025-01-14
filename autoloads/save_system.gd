extends Node

const inventory_path := "user://inventory.dat"
const location_path := "user://location.dat"
const chest_state_path := "user://chests.dat"
const quests_path := "user://quests.dat"
const fast_travel_path := "user://fast_travel.dat"
const stats_path := "user://stats.dat"

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

func save_game() -> void:
	print("[save_system] saving game")


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

	var stats := {
		player_skin = Skins.chosen_skin
	}
	
	store_dictionary(location_path, location)
	store_dictionary(inventory_path, PlayerInventory.serialize())
	store_dictionary(chest_state_path, { chests = ChestBetweenScenes.opened_chest })
	store_dictionary(quests_path, quests)
	store_dictionary(fast_travel_path, { fast_travel_points = fast_travel_points })
	store_dictionary(stats_path, stats)

func load_game() -> void:
	# TODO: handle no save
	print("[save_system] loading game")
	
	var stats := get_dictionary(stats_path)
	Skins.chosen_skin = stats.player_skin

	var fast_travel_points: Array[Dictionary] = get_dictionary(fast_travel_path).fast_travel_points
	for tp in fast_travel_points:
		var travel_point := TravelPoint.new(tp.scene, tp.entry_point)
		if not FastTravelPoints.point_unlocked(travel_point):
			FastTravelPoints.add_to_travel_points(travel_point)

	var quests := get_dictionary(quests_path)
	for quest_id: String in quests.keys():
		var state: Quest.State = quests[quest_id]
		var quest := QuestSystem._find_quest_by_id(quest_id)
		quest.state = state

		if state == Quest.State.ASSIGNED:
			quest._assign_hook()

	ChestBetweenScenes.opened_chest = get_dictionary(chest_state_path).chests

	PlayerInventory.deserialize(get_dictionary(inventory_path))

	var location := get_dictionary(location_path)
	EntryPoints.current_entry_point = location.last_entry_point
	SceneTransition.change_scene(load(location.last_scene_path))
