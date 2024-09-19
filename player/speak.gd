extends Node2D

#@onready var player: Node2D = get_tree().get_first_node_in_group("Player")
@export var radius: float = 15
@export var bark_time: float = 1.0
@export var movement_multiplier: float = 0.2

var _is_active: bool = false


func _ready() -> void:
	var auraTransform: Transform2D = $Aura.transform
	auraTransform.get_scale().x = radius * 5
	auraTransform.get_scale().y = radius * 5
	
	
func speak() -> void:
	_is_active = true
	#toggle the aura
	$Aura.set_process(true)
	$Aura.show()
	#schedule a task to deactivate
	
func unspeak() -> void:
	#toggle off the aura
	$Aura.hide()
	$Aura.set_process(false)
	_is_active = false
	pass
	
func is_active() -> bool:
	return _is_active
	
