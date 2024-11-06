## keeps track of what bark switches have been hit and checks the order
extends Node2D

## The proper order of switches to hit
@export var bark_switches: Array[BarkSwitch]

#the switches the player has hit
var switches_hit: Array[BarkSwitch] 

## Emitted when the all bark switches are hit in the proper order
signal switch_activated

func switch_hit(switch: BarkSwitch) -> void:
	print(switch.get_path(), " has been hit")
	switches_hit.append(switch) #add switch to list
	if(switches_hit.size() >= bark_switches.size()): #when all switches has been hit check the order
		_order_check()

func _order_check() -> void:
	if bark_switches == switches_hit:
		print("You hit the switches in the correct order!")
		switch_activated.emit()
		#victory sfx
	else:
		#wrong order, switches take a sec to turn off so player knows what happened
		await get_tree().create_timer(0.3).timeout
		flip_switches()

#Turns off switches if they are in the wrong order
func flip_switches() -> void:
	for children in get_children():
		if(children.has_method("deactivate")):
			children.deactivate()
	switches_hit.clear()
	print("Wrong order :(")
	#insert wrong sfx
