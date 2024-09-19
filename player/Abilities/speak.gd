extends Node2D

#@onready var player: Node2D = get_tree().get_first_node_in_group("Player")
@export var radius: float = 1
@export var bark_time: float = 1.0
@export var movement_multiplier: float = 0.2

var _is_active: bool = false

	
func speak() -> void:
	_is_active = true
	#toggle the aura
	#schedule a task to deactivate
	
func unspeak() -> void:
	#toggle off the aura
	_is_active = false
	pass
	
func is_active() -> bool:
	return _is_active
	
