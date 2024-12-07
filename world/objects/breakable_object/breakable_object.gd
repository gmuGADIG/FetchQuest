class_name BreakableObject extends StaticBody2D

@onready var not_broken := get_node("BreakableWall")
@onready var broken := get_node("BrokenWall")
@onready var hitbox := get_node("Hitbox")
@export_range(0, 1) var pickup_drop_chance: float = 0.5 ## Chance of dropping a pick-up 
@export_flags("Undefined", "Bomb") var breakable_by: int = DamageEvent.DamageType.Undefined
func hurt(_damage_event: DamageEvent) -> void:
	#If no shared damage type, skip
	if _damage_event.damage_type & breakable_by == 0:
		return
	#Totally not stolen from enemine
	if (randf() <= pickup_drop_chance):
		drop_item()
	
	#Change collision & Sprite to broken
	not_broken.hide()
	broken.show()
	set_collision_layer_value(1,false)
	set_collision_layer_value(3,false)
	
func drop_item() -> void:
		# add bombs, health, and stamina to the list of possible drops, after checking if they're eligible
		var eligible_pickup_paths: Array[String]
		if (Player.instance.health < Player.instance.max_health):
			eligible_pickup_paths.append("res://world/interactable/pickups/pickup_health.tscn") # health
		if (PlayerInventory.bombs < PlayerInventory.max_bombs):
			eligible_pickup_paths.append("res://world/interactable/pickups/pickup_bomb.tscn") # bomb
		eligible_pickup_paths.append("res://world/interactable/pickups/pickup_stamina.tscn") # stamina (unconditional)
		
		# If, somehow, there are no eligible items, then sound the alarms and bail 
		if (eligible_pickup_paths.is_empty()):
			push_error("breakable_object.gd: No valid pickup drops were possible!")
			return
		
		# pick an eligible item and get the scene path
		var chosen: String = eligible_pickup_paths.pick_random()
		var dropped_item: Node2D = load(chosen).instantiate()
		dropped_item.position = position
		add_sibling.call_deferred(dropped_item)
		print("Item '", dropped_item.name, "' was dropped by ", get_path())

func _ready() -> void:
	#Change collision & Sprite to unbroken
	not_broken.show()
	broken.hide()
	set_collision_layer_value(1,true)
	set_collision_layer_value(3,true)
	
