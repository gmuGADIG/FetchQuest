extends CanvasLayer

# construct list of quests
# handle quest being clicked & display quest

var entry_scene: PackedScene = preload("quest_entry/quest_entry.tscn")

@onready var right_page: Control = %RightPage

@onready var left_page_placeholder: Control = %LeftPagePlaceholder
@onready var entry_storage: Control = %QuestEntryStorage
@onready var completion_stamp: Control = %QuestCompletionStamp
@onready var title: Label = %QuestTitle
@onready var description: Label = %QuestDescription
@onready var reward: Label = %QuestReward

var entry_to_quests: Dictionary = {}

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_quest_book"):
		if visible:
			_on_back_button_pressed()
		elif not get_tree().paused:
			_display()

func _ready() -> void:
	visible = false

func _on_entry_clicked(entry: QuestEntry) -> void:
	for e: QuestEntry in entry_to_quests.keys():
		e.selected = false

	entry.selected = true

	var quest: Quest = entry_to_quests[entry]

	title.text = quest.display_name
	description.text = quest.description
	reward.text = "%s Good Boy Points" % quest.good_boy_reward
	completion_stamp.visible = quest.is_completed()

	right_page.visible = true

func _display() -> void:
	visible = true
	get_tree().paused = true 

	for child in entry_storage.get_children():
		child.queue_free()
	
	right_page.visible = false
	left_page_placeholder.visible = true

	var first_entry: QuestEntry = null
	for quest in QuestSystem.quests:
		if quest.is_unassigned(): return

		var entry: QuestEntry = entry_scene.instantiate()
		entry.quest_name = quest.display_name
		entry.main_quest = quest.is_main_quest
		entry.clicked.connect(_on_entry_clicked.bind(entry))
		entry_storage.add_child(entry)
		entry_to_quests[entry] = quest

		left_page_placeholder.visible = false
		if first_entry == null: 
			first_entry = entry
	
	if first_entry:
		_on_entry_clicked(first_entry)

func _on_back_button_pressed() -> void:
	get_tree().paused = false
	visible = false
