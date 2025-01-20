@tool
class_name QuestEntry extends HBoxContainer

signal clicked

@export var quest_name := "QUEST TITLE GOES HERE :D":
	set(v):
		quest_name = v
		_update()

@export var selected := false:
	set(v):
		selected = v
		_update()

@export var main_quest := false:
	set(v):
		main_quest = v
		_update()

@onready var button: Button = %Button

func _update() -> void:
	if not is_node_ready(): return

	button.text = quest_name

	if selected:
		modulate = Color(.9, .9, .9)
	elif main_quest:
		modulate = Color(1., 1., .4)
	else:
		modulate = Color(.6, .6, .6)

func _ready() -> void:
	_update()

func _on_button_pressed() -> void:
	clicked.emit()
