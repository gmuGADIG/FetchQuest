class_name BreakableObject extends StaticBody2D

@onready var not_broken := get_node("BreakableWall")
@onready var broken := get_node("BrokenWall")
@onready var hitbox := get_node("Hitbox")

func hurt(_damage_event: DamageEvent) -> void:
	#Totally not stolen from enemine
	if (randf() > 0.9): return
	
	# add bombs, health, and stamina to the list of possible drops, after checking if they're eligible
	var eligible_pickup_paths: Array[String]
	if (Player.instance.health < Player.instance.max_health):
		eligible_pickup_paths.append("res://world/environment/pickups/pickup_health.tscn") # health
	if (PlayerInventory.bombs < PlayerInventory.max_bombs):
		eligible_pickup_paths.append("res://world/environment/pickups/pickup_bomb.tscn") # bomb
	eligible_pickup_paths.append("res://world/environment/pickups/pickup_stamina.tscn") # stamina (unconditional)
	
	# If, somehow, there are no eligible items, then sound the alarms and bail 
	if (eligible_pickup_paths.is_empty()):
		push_error("enemy.gd: No valid pickup drops were possible!")
		return
	
	# pick an eligible item and get the scene path
	var chosen: String = eligible_pickup_paths.pick_random()
	var dropped_item: Node2D = load(chosen).instantiate()
	dropped_item.position = position
	add_sibling.call_deferred(dropped_item)
	print("Item '", dropped_item.name, "' was dropped by ", get_path())
	
	not_broken.hide()
	broken.show()
	set_collision_layer_value(1,false)
	set_collision_layer_value(3,false)
	
	

func _ready() -> void:
	not_broken.show()
	broken.hide()
	set_collision_layer_value(1,true)
	set_collision_layer_value(3,true)
	
