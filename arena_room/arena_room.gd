@tool
extends Node2D

## A door/wall that will be loaded in when the player enters the arena room
@export var door:Node2D:
	set(v):
		door = v
		update_configuration_warnings()
## An Area2D that will detect when the player enters the room
@export var door_trigger:Node2D:
	set(v):
		door_trigger = v
		update_configuration_warnings()

var enemies:Array
var disable:bool = false
var door_triggered := false

func _get_configuration_warnings() -> PackedStringArray:
	var result := PackedStringArray()

	if door == null:
		result.push_back("`door` property not set in inspector!")

	if door_trigger == null:
		result.push_back("`door_trigger` property not set in inspector!")
	
	return result

func _ready() -> void:
	if Engine.is_editor_hint(): return

	for warning in _get_configuration_warnings():
		assert(false, warning)

	door_trigger.body_entered.connect(_on_door_trigger_body_entered)

	enemies = get_enemies()
	disable_enemies()
	remove_child(door)

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return

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

func _on_door_trigger_body_entered(body: Node2D) -> void:
	if door_triggered: return 
	if body is not Player:
		return

	door_triggered = true
	enable_enemies.call_deferred()
	add_child.call_deferred(door)
	door_trigger.queue_free()

func all_enemies_dead() -> bool:
	for i in range(len(enemies)):
		if is_instance_valid(enemies[i]):
			return false
	return true
