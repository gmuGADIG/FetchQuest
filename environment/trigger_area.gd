extends Area2D
class_name TriggerArea

signal touched_by(object: Node2D)
signal object_left(object: Node2D)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(signal_touch)
	body_exited.connect(signal_leave)

func signal_touch(body: Node2D) -> void:
	touched_by.emit(body)
	
func signal_leave(body: Node2D) -> void:
	object_left.emit(body)
