extends Node2D

@export var required_activation_count := 2

signal switch_activated
signal switch_deactivated

var current_count := 0

func activate() -> void:
	current_count += 1
	if current_count == required_activation_count:
		switch_activated.emit()
		print("Multi-activator activated")

func deactivate() -> void:
	if current_count == required_activation_count:
		switch_deactivated.emit()
		print("Multi-activator deactivated")
	current_count -= 1
