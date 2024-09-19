extends Node2D

var num_red_coins :int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
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
	pass
