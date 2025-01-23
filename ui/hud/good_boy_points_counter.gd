class_name GoodBoyPointsCounter extends Control

static var instance: GoodBoyPointsCounter

@onready var reveal_pos := position
@onready var hidden_pos := reveal_pos + Vector2(0, 110)
@onready var label: Label = %GoodBoyPointsLabel

func _init() -> void:
	instance = self

func reveal() -> void:
	visible = true

	var tween := create_tween()
	position = hidden_pos
	tween.tween_property(self, "position", reveal_pos, .25)

	await tween.finished

#hide is already taken :(
func unreveal() -> void:
	var tween := create_tween()
	position = reveal_pos 
	tween.tween_property(self, "position", hidden_pos, .25)

	await tween.finished
	visible = false

var animate_tween: Tween
func _animate_counter(target: int) -> void:
	if animate_tween != null and animate_tween.is_running():
		animate_tween.stop()
		label.text = str(PlayerInventory.good_boy_points)
	animate_tween = create_tween()

	ignore_inventory_signal = true
	PlayerInventory.good_boy_points = target
	ignore_inventory_signal = false
	
	var starting_value := int(label.text)
	var delta := absi(starting_value - target)
	animate_tween.tween_method(func(v: int) -> void: label.text = str(v), starting_value, target, delta / 15.)

	await animate_tween.finished

var ignore_inventory_signal := false
func _on_good_boy_points_updated() -> void:
	if ignore_inventory_signal: return
	_animate_counter(PlayerInventory.good_boy_points)

func _on_quest_completed(quest: Quest) -> void:
	if quest.good_boy_reward == 0: return

	await reveal()
	await _animate_counter(PlayerInventory.good_boy_points + quest.good_boy_reward)
	await get_tree().create_timer(.5).timeout
	await unreveal()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("gbp_debug") and OS.has_feature("editor"):
		var q := Quest.new()
		q.display_name = "test quest"
		q.good_boy_reward = randi_range(100,300)
		QuestSystem.quest_completed.emit(q)

func _ready() -> void:
	visible = false
	label.text = str(PlayerInventory.good_boy_points)
	PlayerInventory.good_boy_points_updated.connect(_on_good_boy_points_updated)
	QuestSystem.quest_completed.connect(_on_quest_completed)
