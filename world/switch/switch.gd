extends Area2D

signal switch_activated

var activated := false

enum SWITCH_TYPE {
	OneShot,
	Toggle,
	Timed
}

@export var type: SWITCH_TYPE = SWITCH_TYPE.OneShot

#@export var 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_area_entered(area: Area2D) -> void:
	switch_activated.emit()
	pass # Replace with function body.
func _mouse_enter() -> void:
	print("mouse enter")
	switch_activated.emit()
	
func activate_switch() -> void:
	match(type):
		SWITCH_TYPE.OneShot:
			if not activated:
				activated = true
				switch_activated.emit()
		_: 
			pass
