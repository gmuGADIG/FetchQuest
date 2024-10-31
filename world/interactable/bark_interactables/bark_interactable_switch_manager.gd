extends Node2D

@export var bark_switches: Array[Area2D]

var switches_hit: Array[String] 
var num_hit: int = 0

var correct_order := false
signal deactivae_switches
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func switch_hit(switch: String) -> void:
	print(switch)
	switches_hit.append(switch)
	num_hit += 1
	if(num_hit >= bark_switches.size()):
		_order_check()
		

	
func _order_check() -> void:
	correct_order = true
	var i := 0;
	var array_size : int = bark_switches.size()
	while i < array_size:
		if(bark_switches[i].name != switches_hit[i]): correct_order = false
		i+= 1;
	if correct_order:
		print("You hit the switches in the correct order!")
	else:
		num_hit = 0
		correct_order = false
		var delay := Timer.new()
		add_child(delay)
		delay.one_shot = true
		delay.start(0.1)
		delay.timeout.connect(flip_switches)
		
		
	pass
	
func flip_switches() -> void:
	for children in get_children():
		if(children.has_method("deactivate")):
			children.deactivate()
	switches_hit.clear()
	print("Wrong order :(")
	pass
