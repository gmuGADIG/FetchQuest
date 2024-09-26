extends Area2D
##Make sure to have a RedCoinManager in your scene!
@onready var red_coin_manager := $"../RedCoinManager"
@onready var my_label := $Label
@export var label_visible_time: float = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	red_coin_manager._addRedCoin() #tells Manager it exist
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		#sound plays update UI?
		print("Picked up a coin")
		var coin_num: int = red_coin_manager._subtractRedCoin() 
		#tells manager its been picked up and gets its number in return
		
		my_label.text = str(coin_num)
		#"deletes" coin
		$CollisionShape2D.queue_free()
		$Sprite2D.queue_free()
		#waits a time then deletes entire object
		await get_tree().create_timer(label_visible_time).timeout
		queue_free()
	else:
		print("That isn't the player")
	pass # Replace with function body.
	
