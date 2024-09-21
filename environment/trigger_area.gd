extends Area2D
class_name TriggerArea

signal touched_by(object: Node2D)  ## Wrapper signal for body_entered
signal object_left(object: Node2D) ## Wrapper signal for object_left

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(signal_touch)
	body_exited.connect(signal_leave)

## Intermediate function to catch and resend the body_entered signal. Any logic intended to run beforehand should go here.
func signal_touch(body: Node2D) -> void:
	touched_by.emit(body)
	
## Intermediate function to catch the body_exited signal. Additional code can go here.
func signal_leave(body: Node2D) -> void:
	object_left.emit(body)
