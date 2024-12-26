class_name King extends Node2D

@export_group("Movement")
@export var movement_points:Array[Node2D]
@onready var previous_teleport_position:Vector2 = global_position

@export_group("Attack Selection")
@export var mushroom_state:KingMushroomState
@export var throw_state:KingThrowState
@export var whistle_state:KingWhistleState
@onready var attack_states:Array = [mushroom_state, throw_state, whistle_state]
var previous_attack_state:KingState = null
@export var mushroom_state_weight:float = 1.0 / 3.0
@export var throw_state_weight:float = 1.0 / 3.0
@export var whistle_state_weight:float = 1.0 / 3.0
@onready var attack_state_weights:Array = [mushroom_state_weight, throw_state_weight, whistle_state_weight]

@export_group("Exploding Mushrooms")
var mushroom_scene:PackedScene = preload("res://enemy/king_boss/king_exploding_mushroom.tscn")
@export var mushroom_count:int = 50
@export var room_center:Node2D
@export var room_size:Vector2

@export_group("State Durations")
@export var mushroom_state_duration:float = 2
@export var idle_state_duration:float = 2

func randomly_move() -> void:
	while global_position == previous_teleport_position:
		global_position = movement_points.pick_random().global_position
	previous_teleport_position = global_position

func _on_random_teleport_timer_timeout() -> void:
	randomly_move()
