extends CharacterBody2D

@onready var area: Area2D = %Area2D
@onready var sprite: Sprite2D = %Sprite2D

var pressed := false

signal switch_activated
signal switch_deactivated

func _process(_delta: float) -> void:
	var pressed_this_frame := area.has_overlapping_bodies()

	if pressed != pressed_this_frame:
		if pressed_this_frame:
			switch_activated.emit()
		if pressed_this_frame:
			switch_deactivated.emit()

	pressed = pressed_this_frame

	if pressed:
		sprite.frame = 1
	else:
		sprite.frame = 0

func get_pressed() -> bool:
	return pressed
