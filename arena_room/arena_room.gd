extends Node2D

@export var door:Node2D
@export var door_trigger:Area2D

var enemies:Array
var disable:bool = false

func _ready() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame
	enemies = get_enemies()
	disable_enemies()
	remove_child(door)

func _process(delta: float) -> void:
	if disable:
		return
	if all_enemies_dead():
		door.queue_free()
		disable = true

func get_enemies() -> Array:
	var arr := []
	for child in get_children():
		if child is Enemy:
			arr.append(child)
	return arr

func disable_enemies() -> void:
	for enemy:Enemy in enemies:
		remove_child(enemy)
		
func enable_enemies() -> void:
	for enemy:Enemy in enemies:
		add_child(enemy)

func door_triggered(body: Node2D) -> void:
	if body is not Player:
		return
	enable_enemies()
	add_child(door)
	door_trigger.queue_free()

func all_enemies_dead() -> bool:
	for i in range(len(enemies)):
		if is_instance_valid(enemies[i]):
			return false
	return true
