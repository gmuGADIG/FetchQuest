extends Area2D

@onready var red_coin_manager: RedCoinManager = get_parent()
@onready var my_label := $Label
@export var label_visible_time: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(red_coin_manager != null, "Red coin at %s was not a child of a RedCoinManager!" % get_path())
	red_coin_manager.increment_coin_count() #tells Manager it exist

func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		# sound plays update UI?
		print("RedCoin: picked up")
		var coin_num: int = red_coin_manager.red_coin_collected() 
		# tells manager its been picked up and gets its number in return
		
		my_label.text = str(coin_num)
		
		# "deletes" coin (hides sprite and prevents further collision)
		$CollisionShape2D.queue_free()
		$Sprite2D.queue_free()
		
		# waits a time then deletes entire object
		await get_tree().create_timer(label_visible_time).timeout
		queue_free()
	else:
		print("RedCoin: that isn't the player")
	
