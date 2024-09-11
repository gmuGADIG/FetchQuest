class_name Health extends Node

## Emitted when the this entity has died.
signal died

## Emitted when the health of this entity has changed.
signal health_changed(old_health: float)

var dead := false

## The maximum amount of health this entity can have
@export var max_health: float = 3.0

## The current health this entity has
@onready var health := max_health:
	set(v):
		if dead: # the dead cannot heal*
			health = 0
			return

		v = clampf(v, 0, max_health)

		var old_health := health
		health = v
		health_changed.emit(old_health)

		if v == 0:
			dead = true
			died.emit()
		
		print("health.gd: '%s' health set to %s" % [get_parent().get_path(), health])
