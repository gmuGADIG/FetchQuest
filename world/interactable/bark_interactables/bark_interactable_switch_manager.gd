extends Node2D

@export var bark_switches: Array[Node2D]

var switches_hit: Array[Node2D]
var num_hit: int

var correctOrder := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_bark_switch_switch_activated(switch: Node2D) -> void:
	switches_hit[num_hit] = switch
	num_hit += 1
	if(num_hit >=bark_switches.size()):
		_order_check()
	pass # Replace with function body.
	
func _order_check() -> void:
	correctOrder = true
	for i in bark_switches.size:
		if(bark_switches[i] !=switches_hit[i]): correctOrder = false
	pass
