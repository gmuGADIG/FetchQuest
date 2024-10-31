extends Node2D

## keeps track of what bark switches have been hit and checks the order

#the proper order of switches to hit
@export var bark_switches: Array[Area2D]

#the switches the player has hit and tracking variables
var switches_hit: Array[String] 
var num_hit: int = 0

var correct_order := false
signal deactivae_switches


func switch_hit(switch: String) -> void:
	print(switch + " has been hit")
	switches_hit.append(switch) #add switch to list
	num_hit += 1
	if(num_hit >= bark_switches.size()): #when all switches has been hit check the order
		_order_check()
		

	
func _order_check() -> void:
	correct_order = true
	var i := 0;
	var array_size : int = bark_switches.size()
	#so Godot doesn't have a standard 3 part for loop so while loop to see compare list
	while i < array_size:
		if(bark_switches[i].name != switches_hit[i]): correct_order = false
		i+= 1;
	if correct_order:
		print("You hit the switches in the correct order!")
		#add code to trigger an event here
		#victory sfx
	else:
		num_hit = 0
		correct_order = false
		#wrong order, switches take a sec to turn off so player knows what happened
		var delay := Timer.new()
		add_child(delay)
		delay.one_shot = true
		delay.start(0.3)
		delay.timeout.connect(flip_switches)
		
	pass
	
#Turns off switches if they are in the wrong order
func flip_switches() -> void:
	for children in get_children():
		if(children.has_method("deactivate")):
			children.deactivate()
	switches_hit.clear()
	print("Wrong order :(")
	#insert wrong sfx
	pass
