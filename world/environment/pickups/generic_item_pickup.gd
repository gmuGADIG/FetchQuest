class_name GenericItemPickup extends CharacterBody2D

## GENERIC ITEM PICKUP

## This is for when the player picks up standard stuff like bombs and health. Things that make numbers go up, instead of quest items or keys.

## This enum holds the possible item types. Add more as needed.
## This is being restated every time an item spawns. Maybe should be in an autoload elsewhere?
enum item_type {
	HEALTH,
	BOMB,
	STAMINA
}

## Now we tell this particular instance what its identity is, what part of the enum it is.
@export var identity:=item_type.HEALTH
@export var amount: int = 1
#func _ready() -> void:
#	assert(inventory_key != "", "Item '%s' has an empty inventory key!" % inventory_key)


func _on_pickup_area_body_entered(body: Node2D) -> void:
	if body is not Player: return

	match identity:
		item_type.HEALTH:
			if body.health>=body.max_health:return
			body.heal(amount)
		item_type.BOMB:
			PlayerInventory.bombs += amount
		item_type.STAMINA:
			body.stamina = move_toward(body.stamina, body.max_stamina, amount)
	queue_free()
