# NOTE: This script applies to all enemies.
# To create a new enemy, create an inherited scene from the base enemy, then 
# replace the existing script with a new script extending `Enemy`.

class_name Enemy extends CharacterBody2D

signal died
signal health_changed(old_health: int)

@export var max_health: int = 3
var dead := false
var health := max_health:
	set(v):
		if dead: return

		var old_health := health
		health = v
		health_changed.emit(old_health)

		print("Enemy '%s' health was set to %s." % [get_path(), health])

		if health <= 0:
			dead = true
			died.emit()
			queue_free()
