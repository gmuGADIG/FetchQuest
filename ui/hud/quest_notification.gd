extends Control

@onready var title_label: Label = %QuestTitle
@onready var description_label: Label = %Description

@onready var description_format := description_label.text
@onready var title_format := title_label.text

@onready var hidden_pos := position
@onready var reveal_pos := position + Vector2(0, 150)

func reveal() -> void:
	var tween := create_tween()
	position = hidden_pos
	tween.tween_property(self, "position", reveal_pos, .25)
	await tween.finished

func unreveal() -> void:
	var tween := create_tween()
	position = reveal_pos 
	tween.tween_property(self, "position", hidden_pos, .25)
	await tween.finished

func _on_quest_completed(quest: Quest) -> void:
	title_label.text = title_format % quest.display_name
	description_label.text = description_format % quest.good_boy_reward

	await reveal()
	await get_tree().create_timer(quest.good_boy_reward / 50. + .5).timeout
	await unreveal()

func _ready() -> void:
	QuestSystem.quest_completed.connect(_on_quest_completed)
