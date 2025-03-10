class_name WeakFloor extends Node2D
## When stood on by players or enemies, slowly decays.
## Prevents players or enemies from falling in holes while it is still alive.

@onready var _area_2d := $Area2D
@onready var _hole_occluder_collision := $HoleOccluder/CollisionShape2D
@onready var _sprite := $Sprite2D

## How long the floor can be stood on before it disappears.
@export var safe_length: float = 0.75

## How long it takes for the floor to respawn. Set to -1 to disable respawning.
@export var respawn_time: float = 1.5

var alive: bool = true

## Stores the timer for either safe_length or respawn_time.
var timer: float = 0.0

func _ready() -> void:
	# We start alive.
	_set_alive_and_reset_timer(true)

func _set_alive_and_reset_timer(new_alive: bool) -> void:
	timer = 0
	alive = new_alive
	_hole_occluder_collision.disabled = not alive
	
	_animate_decay(0.0 if alive else 1.0)
		
# Sets the "decay" animation to a specific "time" between 0 and 1. For now
# just changes the modulate.
func _animate_decay(how_decayed: float) -> void:
	const color_good = Color.WHITE
	const color_decay = Color.DIM_GRAY
	_sprite.modulate = color_good.lerp(color_decay, how_decayed)
	
	if how_decayed >= 1.0:
		hide()
	else:
		show()

func _process(delta: float) -> void:
	if alive:
		# When we're alive, set alpha based on how much time remains.
		# This is done before the timer reset to avoid a visual glitch.
		_animate_decay(timer / safe_length)
		
		if _area_2d.has_overlapping_bodies():
			timer += delta
			if timer >= safe_length:
				_set_alive_and_reset_timer(false)
		else:
			# Have the timer tick back down when nothing is on the platform.
			timer = max(timer - delta, 0)
		
	else:
		timer += delta
		# ALways look fully decayed.
		_animate_decay(1.0)
		if timer >= respawn_time:
			_set_alive_and_reset_timer(true)
	
