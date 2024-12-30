class_name King extends CharacterBody2D

@export_group("Stats")
@export var max_health:int = 10
@onready var health:int = max_health:
	# Emit a signal when the health is changed
	set(value):
		health = value
		health_changed.emit()
## The signal emitted when the health is changed
signal health_changed


@export_group("Movement")
@export var movement_points:Array[Node2D]
@export var time_between_teleports:float = 1
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

@export_group("Mushroom Cloud")
var mushroom_scene:PackedScene = preload("res://enemy/king_boss/king_exploding_mushroom.tscn")
@export var mushroom_count:int = 50
@export var room_center:Node2D
@export var room_size:Vector2

@export_group("Dog Whistle")
@export var total_shockwaves:int = 10
@onready var time_between_shockwaves:float = whistle_state_duration / total_shockwaves

@export_group("Scepter Throw")
var thrown_scepter_scene:PackedScene = preload("res://enemy/king_boss/king_thrown_scepter.tscn")
@export var total_scepter_throws:int = 2
var lost_scepter_scene:PackedScene = preload("res://enemy/king_boss/king_dropped_scepter.tscn")
var current_lost_scepter:KingDroppedScepter = null

@export_group("Vulnerable State")
@export var panic_distance:float = 200
@export var panic_speed:float = 200 
@export var panic_duration:float = 4
@onready var total_panic_points:int = floori(panic_distance / panic_speed * panic_duration)
@onready var bubble_sprite:Sprite2D = $BubbleSprite

@export_group("State Durations")
@export var idle_state_duration:float = 2
@export var mushroom_state_duration:float = 2
@export var whistle_state_duration:float = 2

func _ready() -> void:
	$RandomTeleportTimer.wait_time = time_between_teleports
	$RandomTeleportTimer.start()

func randomly_move() -> void:
	while global_position == previous_teleport_position:
		global_position = movement_points.pick_random().global_position
	previous_teleport_position = global_position


func _on_random_teleport_timer_timeout() -> void:
	if $KingStateMachine.current_state is KingVulnerableState:
		return
	randomly_move()

func hurt(damage_event:DamageEvent) -> void:
	if $KingStateMachine.current_state is not KingVulnerableState:
		return
	health -= damage_event.damage
	print("king_boss.gd: Health lowered to %s/%s" % [health, max_health])
