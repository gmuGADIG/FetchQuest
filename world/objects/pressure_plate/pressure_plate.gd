extends CharacterBody2D

@onready var pressed := false

func _process(delta: float) -> void:
	pressed = $Area2D.has_overlapping_bodies()
	if(pressed):
		$Sprite2D.frame = 1
	else:
		$Sprite2D.frame = 0
	pass

func get_pressed() -> bool:
	return pressed
