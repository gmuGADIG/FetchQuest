extends Node2D

##How it works: First place reward in scene, assign it in the inspector
## on start it will hide the reward and see how many redCoins there are
## when all the red coins are picked up it will unhide the reward.

var num_red_coins :int
var coins_picked_up: int
#maybe add var for number of coins picked up for UI
@export var reward : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reward.set_process(false)
	reward.set_physics_process(false)
	reward.get_node("PickupArea").monitoring = false
	reward.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _addRedCoin() -> void:
	num_red_coins += 1 #counting the coins in the scene
	print("There are " + str(num_red_coins) + " red coins")
	pass

func _subtractRedCoin() -> int:
	num_red_coins -= 1 #Down one coin
	coins_picked_up += 1 #this is the nth coin picked up
	if(num_red_coins == 0):
		_allRedCoins()
	return coins_picked_up
	pass
	
func _allRedCoins() -> void:
	print("all red coins collected!")
	#play sound yipee!
	reward.set_process(true)
	reward.set_physics_process(true)
	reward.set_process_input(true)
	reward.get_node("PickupArea").monitoring = true
	reward.visible = true
	pass
