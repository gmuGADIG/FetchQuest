extends Area2D

signal switch_activated
signal switch_deactivated
var activated := false

enum SWITCH_TYPE {
	OneShot,
	Toggle,
	Timed
}

@export var type: SWITCH_TYPE = SWITCH_TYPE.OneShot
@export var active_time: float = 0.0
var _timer: Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_timer = get_node("Timer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_area_entered(area: Area2D) -> void:
	trigger_switch()
func _mouse_enter() -> void:
	print("mouse enter")
	trigger_switch()
	
func trigger_switch() -> void:
	match(type):
		SWITCH_TYPE.OneShot:
			if not activated:
				activated = true
				switch_activated.emit()
				
		SWITCH_TYPE.Toggle:
			activated = not activated
			if activated:
				switch_activated.emit()
			else:
				switch_deactivated.emit()	
		SWITCH_TYPE.Timed:
			if not activated:
				activated = true
				switch_activated.emit()
				_timer.start(active_time)
			else:
				#restart timer
				_timer.stop()
				_timer.start(active_time)


func _on_timer_timeout() -> void:
	if activated:
		activated = false
		switch_deactivated.emit()
