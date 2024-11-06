extends HBoxContainer

#@onready var heart : PackedScene = load("uid://crx66rsu01asx")
var empty_heart := preload("res://ui/hud/empty_heart.tscn")
var half_heart := preload("res://ui/hud/half_heart.tscn")
var full_heart := preload("res://ui/hud/full_heart.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Updates the heart display for the first time, then connects
	# to Player.health_changed signal for future updates
	Player.instance.health_changed.connect(update_heart_display)
	update_heart_display.call_deferred()

## Updates the heart display on the HUD
func update_heart_display() -> void:
	
	
	
	# Remove all the children first
	for _child in get_children():
		remove_child(_child)
		_child.queue_free()
	
	
	var num_hearts : int = Player.instance.max_health/2
	var health : int = Player.instance.health
	
	
	
	# Then add in the amount of hearts back
	for heart in range(0,num_hearts):
		if(health>=2):
			add_child(full_heart.instantiate())
		elif(health==1):
			add_child(half_heart.instantiate())
		else:
			add_child(empty_heart.instantiate())
		
		health -=2
		
		
	# NOTE: A better way to do this might be to remove the amount of
	# hearts needed, but this implementation is sufficient for any
	# amount of health lost (aka intended to be robust/future-proof)
