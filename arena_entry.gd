extends Node

@onready var entry_sprite : Sprite2D = $Sprite2D
@onready var entry_collider : CollisionShape2D = $CollisionShape2D
@onready var entry_trigger : CollisionShape2D = $entry_trigger/CollisionShape2D

var enemies : Array[Enemy]

func _ready() -> void:
	entry_sprite.visible = false
	for child in get_children():
		if child is not Enemy: continue
		enemies.append(child)
		remove_child(child)


func _on_entry_trigger_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	entry_sprite.visible = true
	entry_collider.disabled = false
	
	#Create Array of Enemies
	for enemy in enemies:
		add_child(enemy)
	
	entry_trigger.disabled = true
