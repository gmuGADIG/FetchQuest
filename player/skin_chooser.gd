extends Node2D

@onready var skins: Array[Node2D] = [%Skin1, %Skin2, %Skin3]

func _ready() -> void:
	for idx in skins.size():
		skins[idx].visible = Skins.chosen_skin - 1 == idx
