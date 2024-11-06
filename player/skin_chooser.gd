extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if ChosenSkin.chosen_skin == 1:
		$"../skin1".visible = true
	if ChosenSkin.chosen_skin == 2:
		$"../skin2".visible = true
	if ChosenSkin.chosen_skin == 3:
		$"../skin3".visible = true
