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
var _on_sprite: Sprite2D
var _off_sprite: Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_timer = get_node("Timer")
	_on_sprite = get_node("OnSprite")
	_off_sprite = get_node("OffSprite")

func _on_area_entered(area: Area2D) -> void:
	trigger_switch()

func trigger_switch() -> void:
	match(type):
		SWITCH_TYPE.OneShot:
			if not activated:
				activate()
				
				
		SWITCH_TYPE.Toggle:
			if activated:
				deactivate()
			else:
				activate()
				
		SWITCH_TYPE.Timed:
			if not activated:
				activate()
				_timer.start(active_time)
			else:
				#restart timer
				_timer.stop()
				_timer.start(active_time)


func activate() -> void:
	activated = true
	switch_activated.emit()
	_on_sprite.visible = true
	_off_sprite.visible = false
	
func deactivate() -> void:
	activated = false
	switch_deactivated.emit()
	_on_sprite.visible = false
	_off_sprite.visible = true

func _on_timer_timeout() -> void:
	if activated:
		deactivate()
