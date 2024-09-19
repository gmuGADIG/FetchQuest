extends Node2D

##How it works: First place reward in scene, assign it in the inspector
# on start it will hide the reward and see how many redCoins there are
# when all the red coins are picked up it will unhide the reward.

var num_red_coins :int
#maybe add var for number of coins picked up for UI
@export var reward : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reward.set_process(false)
	reward.set_physics_process(false)
	reward.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _addRedCoin() -> void:
	num_red_coins += 1
	print("There are " + str(num_red_coins) + " red coins")
	pass

func _subtractRedCoin() -> void:
	num_red_coins -= 1
	if(num_red_coins <= 0):
		_allRedCoins()
	pass
	
func _allRedCoins() -> void:
	print("all red coins collected!")
	#play sound yipee!
	reward.set_process(true)
	reward.set_physics_process(true)
	reward.visible = true
	pass
