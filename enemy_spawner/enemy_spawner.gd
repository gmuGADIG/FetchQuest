extends Node2D


@export var enemy: PackedScene = preload("res://enemy/test_enemy/test_enemy.tscn")



func _on_timer_timeout() -> void:
	var ene: Enemy = enemy.instantiate()
	ene.position = position
	get_parent().add_child(ene)
