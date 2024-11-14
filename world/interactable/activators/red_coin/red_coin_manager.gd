class_name RedCoinManager extends Node2D

signal switch_activated

## The RedCoinManager should have several RedCoin children.
## The reward (set in the inspector) will disappear on start-up, and
## will reappear once all red coins have been picked up.

var num_red_coins :int
var coins_picked_up: int

## Called by each red coin on _ready(). Simply increments the coin count,
## which is used to determine when the final coin is collected
func increment_coin_count() -> void:
	num_red_coins += 1

## Called by the red coin when picked up.
## Returns the number to display above the coin (1 for the first collected, 2 for the next, etc.)
## If this was the final coin, enabled the reward.
func red_coin_collected() -> int:
	num_red_coins -= 1 #Down one coin
	coins_picked_up += 1 #this is the nth coin picked up
	if(num_red_coins == 0):
		enable_reward()
	return coins_picked_up

## Re-enable the reward that was set in the inspector
func enable_reward() -> void:
	print("RedCoinManager: all red coins collected!")
	#play sound yipee!
	switch_activated.emit()
