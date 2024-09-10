class_name HurtBox extends Area2D

@export var health: Health

func _ready() -> void:
	assert(health != null, "Health not set in the inspector!")
	assert(collision_mask != 0, "Collision mask not set!")

	if collision_layer != 0:
		push_warning("Collision layer probably shouldn't be set.")

func _on_area_entered(area: Area2D) -> void:
	var hitbox := area as Hitbox
	if hitbox == null: return

	health.health -= hitbox.damage
