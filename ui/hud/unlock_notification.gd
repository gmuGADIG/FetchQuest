extends Control

@onready var title_label: Label = %UnlockTitle
@onready var description_label: Label = %UnlockDesc

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

func _on_item_updated(key: String) -> void:
	match key:
		"dog_roll_ability":
			title_label.text = "Dog roll unlocked!"
			description_label.text = "Roll with space or left trigger!"
		"bomb_ability":
			title_label.text = "Bombs unlocked!"
			description_label.text = "Throw bomb with right click or right bumper!"
		"bark_ability":
			title_label.text = "Bark unlocked!"
			description_label.text = "Bark with shift or left trigger!"
		_:
			return

	await reveal()
	%UnlockParticles.emitting = true
	await get_tree().create_timer(7.).timeout
	await unreveal()

func _ready() -> void:
	PlayerInventory.item_updated.connect(_on_item_updated)
